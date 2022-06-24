Shader "Custom/alpha2pass"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        // Tags 설정을 Transparent 로 바꿈으로써, 현재 쉐이더를 '알파 블렌드 쉐이더(반투명 쉐이더)'로 변환함.
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}

        //// 1st pass - z버퍼 활성화. 화면에는 그리지 않음.
        zwrite on // z버퍼 활성화
        ColorMask 0 // 이 명령어는 화면에 이 쉐이더의 결과물을 보이지 않도록 함. 
        CGPROGRAM
        // 서피스 쉐이더 생성 시 자동으로 생성되는 추가 쉐이더들을 생성하지 않도록 하여 최대한 계산을 줄임. -> 오직 z버퍼만 그리기 위한 쉐이더임.
        #pragma surface surf nolight noambient noforwardadd nolightmap novertexlights noshadow

        struct Input
        {
            float4 color:COLOR; // 버텍스 컬러값을 구조체에 정의함.
        };

        void surf (Input IN, inout SurfaceOutput o) {
            // 어차피 화면에 안그려줄거기 때문에, surf 함수에서도 아무런 연산을 수행하지 않음.
        }
        
        // 아무런 연산을 하지 않는 커스텀 라이트 함수 -> 원래 필요없지만, 이렇게 껍데기라도 만들어줘야 서피스 쉐이더가 만들어짐.
        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten) {
            return float4(0, 0, 0, 0);
        }
        ENDCG

        // 2nd pass - z버퍼 비활성화. 화면에 그려줌.
        zwrite off // z버퍼 비활성화.
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade // alpha:fade 명령어까지 추가해야 알파 블렌딩(반투명) 쉐이더가 적용됨.

        sampler2D _MainTex;

        struct Input {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o) {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = 0.5;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

/*
    1st pass 는 오직 z버퍼만을 그리기 위해
    만들어진 패스이며, 실제로 화면에 그려지지는 않음.

    즉, z버퍼(깊이정보)가 있는 1st pass 의 픽셀들에 의해
    그 다음에 그려지는 2nd pass 의 픽셀들에서 잘려서 그려지지 않는 픽셀과
    그려지는 픽셀들이 구분될 수 있게 한 것임.

    즉, 1st pass 에서 그려진(실제로 화면에 그려진 건 아님) 픽셀들의 z버퍼를
    사용해서 2nd pass 의 픽셀들을 그려줄 지 말 지 결정하는 기법이라고 보면 됨.
    
    -> 이렇게 함으로써, 알파 블렌딩(반투명) 쉐이더에서 
    앞뒤 판정이 이상하게 되는 문제를 해결할 수 있음.
*/

Shader "Custom/alpha2pass"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        // Tags ������ Transparent �� �ٲ����ν�, ���� ���̴��� '���� ���� ���̴�(������ ���̴�)'�� ��ȯ��.
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}

        //// 1st pass - z���� Ȱ��ȭ. ȭ�鿡�� �׸��� ����.
        zwrite on // z���� Ȱ��ȭ
        ColorMask 0 // �� ��ɾ�� ȭ�鿡 �� ���̴��� ������� ������ �ʵ��� ��. 
        CGPROGRAM
        // ���ǽ� ���̴� ���� �� �ڵ����� �����Ǵ� �߰� ���̴����� �������� �ʵ��� �Ͽ� �ִ��� ����� ����. -> ���� z���۸� �׸��� ���� ���̴���.
        #pragma surface surf nolight noambient noforwardadd nolightmap novertexlights noshadow

        struct Input
        {
            float4 color:COLOR; // ���ؽ� �÷����� ����ü�� ������.
        };

        void surf (Input IN, inout SurfaceOutput o) {
            // ������ ȭ�鿡 �ȱ׷��ٰű� ������, surf �Լ������� �ƹ��� ������ �������� ����.
        }
        
        // �ƹ��� ������ ���� �ʴ� Ŀ���� ����Ʈ �Լ� -> ���� �ʿ������, �̷��� ������� �������� ���ǽ� ���̴��� �������.
        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten) {
            return float4(0, 0, 0, 0);
        }
        ENDCG

        // 2nd pass - z���� ��Ȱ��ȭ. ȭ�鿡 �׷���.
        zwrite off // z���� ��Ȱ��ȭ.
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade // alpha:fade ��ɾ���� �߰��ؾ� ���� ����(������) ���̴��� �����.

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
    1st pass �� ���� z���۸��� �׸��� ����
    ������� �н��̸�, ������ ȭ�鿡 �׷������� ����.

    ��, z����(��������)�� �ִ� 1st pass �� �ȼ��鿡 ����
    �� ������ �׷����� 2nd pass �� �ȼ��鿡�� �߷��� �׷����� �ʴ� �ȼ���
    �׷����� �ȼ����� ���е� �� �ְ� �� ����.

    ��, 1st pass ���� �׷���(������ ȭ�鿡 �׷��� �� �ƴ�) �ȼ����� z���۸�
    ����ؼ� 2nd pass �� �ȼ����� �׷��� �� �� �� �����ϴ� ����̶�� ���� ��.
    
    -> �̷��� �����ν�, ���� ����(������) ���̴����� 
    �յ� ������ �̻��ϰ� �Ǵ� ������ �ذ��� �� ����.
*/

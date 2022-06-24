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

        // 1st pass - z���� Ȱ��ȭ. ȭ�鿡�� �׸��� ����.
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
    }
    FallBack "Diffuse"
}

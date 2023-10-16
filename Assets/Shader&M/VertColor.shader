Shader "Custom/VertMath"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert
        #pragma vertex vert

        #pragma target 5.0

        sampler2D _MainTex;

        struct Input
        {
            float4 vertex : POSITION;
        };

        void vert (inout appdata_full v, out Input o)
        {
            o.vertex = UnityObjectToClipPos(v.vertex);
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 color = sin(IN.vertex.xyz * 0.5 + 0.5); // 根据顶点位置计算颜色
            o.Albedo = color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
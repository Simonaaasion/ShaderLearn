Shader "Custom/QuanXi"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DotProduct("羽化度",Range(-1,1)) = 0.25
    }
    SubShader
    {
        Tags {
                "Queue" = "Transparent"
                "IgnoreProjector" = "True"
                "RenderType" = "Transparent"
             }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard alpha:fade nolighting

        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir;
        };

        fixed4 _Color;
        float _DotProduct;


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            float border = 1 - abs(dot(IN.viewDir,IN.worldNormal));
            float alpha = border * (1 - _DotProduct) + _DotProduct;
            o.Alpha = c.a * alpha;
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}

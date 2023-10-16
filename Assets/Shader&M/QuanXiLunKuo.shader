Shader "Custom/QuanXi_Outline"
{
    Properties
    {
        _Color ("Color", Color) = (1, 0, 0, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _DotProduct("羽化度",Range(-1,1)) = 0.25

    }
    SubShader
    {
        Tags
        {
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
        fixed4 _OutlineColor;
        float _DotProduct;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = texColor.rgb;

            float border = 1 - abs(dot(IN.viewDir, IN.worldNormal));
            float alpha = border * (1 - _DotProduct) + _DotProduct;

            fixed4 outlineColor = _OutlineColor * alpha;
            o.Albedo = lerp(texColor.rgb, outlineColor.rgb, alpha);

            o.Alpha = texColor.a * alpha;
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}
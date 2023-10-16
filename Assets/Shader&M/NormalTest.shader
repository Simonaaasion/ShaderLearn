Shader "Custom/NormalTest"
{
    Properties
    {
        _MainTint ("Diffuse Tint", Color) = (1, 1, 1, 1)
        _NormalTex("Normal Map",2D) = "bump" {}
        _NormalIntensity("Normal Map Intensity",Range(0,2)) = 1
    }
    SubShader
    {
        CGPROGRAM
        //#pragma surface surf Lambert
        #pragma surface surf Standard fullforwardshadows


        sampler2D _NormalTex;

        struct Input
        {
            float2 uv_NormalTex;
        };

        float4 _MainTint;
        float _NormalIntensity;


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float3 normalMap = UnpackNormal(tex2D(_NormalTex,IN.uv_NormalTex));
            normalMap = float3(normalMap.x *_NormalIntensity,normalMap.y * _NormalIntensity,normalMap.z);
            o.Albedo = _MainTint.rgb;
            o.Normal = normalMap.rgb;
           
        }
        ENDCG
    }
    FallBack "Diffuse"
}

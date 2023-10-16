Shader "Custom/NoiseShader"
{
    Properties
    {
        _staticBack("BackGround",2D) = "white" {}
        _MainTint ("Diffuse Tint", color) = (1, 1, 1, 1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _Speed ("Speed", Range(0, 10)) = 1.0
        _Amplitude ("Amplitude", Range(0, 1)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _staticBack;
        sampler2D _MainTex;
        float4 _MainTint;
        sampler2D _NoiseTex;
        float _Speed;
        float _Amplitude;

        void vert(inout appdata_full v)
        {
            // No vertex transformation needed
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv = IN.uv_MainTex;
            float2 noiseUV = uv + _Time.y * _Speed;
            float2 rand = tex2D(_NoiseTex, noiseUV).rg;

            uv += rand * _Amplitude;
            fixed4 c2 = tex2D(_staticBack, IN.uv_MainTex);
            fixed4 c1 = tex2D(_MainTex, uv);
            o.Albedo = (c1.rgb + c2.rgb)* _MainTint;
            o.Alpha = c1.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
// UV 噪声纹理扰动Shader
//实现类似于水面泛起涟漪的效果
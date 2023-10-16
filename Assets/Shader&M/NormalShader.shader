Shader "Custom/NormalShader"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _NormalTex ("Normal Texture", 2D) = "bump" {}
        _DistortionAmount ("Distortion Amount", Range(0, 1)) = 0.5
        _RippleSpeed ("Ripple Speed", Range(0, 10)) = 1.0
        _RippleFrequency ("Ripple Frequency", Range(0, 10)) = 1.0
        _RippleAmplitude ("Ripple Amplitude", Range(0, 1)) = 0.1

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;
        float _DistortionAmount;
        float _RippleSpeed;
        float _RippleFrequency;
        float _RippleAmplitude;

        void vert(inout appdata_full v)
        {
            v.vertex.y += sin(_Time.y * _RippleSpeed + v.vertex.x * _RippleFrequency) * _RippleAmplitude;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;

            float2 uvDistorted = IN.uv_MainTex + _DistortionAmount * tex2D(_NormalTex, IN.uv_MainTex).rg;
            o.Normal = UnpackNormal(tex2D(_NormalTex, uvDistorted));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
//Normal 的偏向扰动Shader
//实现的效果类似于旗帜在空中飘动或者海浪拍打沙滩

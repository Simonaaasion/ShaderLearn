Shader "Custom/SandBrickShader"
{
    Properties
    {
        _BrickTexture ("Brick Texture", 2D) = "white" {}
        _SandTexture ("Sand Texture", 2D) = "white" {}
        _BrickAlphaTexture ("Brick Alpha Texture", 2D) = "white" {}
        _SandAmount ("Sand Amount", Range(0, 1)) = 0.01
        _Color ("Color", color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        #pragma target 3.0

        sampler2D _BrickTexture;
        sampler2D _SandTexture;
        sampler2D _BrickAlphaTexture;

        struct Input
        {
            float2 uv_BrickTexture;
            float2 uv_SandTexture;
            float2 uv_BrickAlphaTexture;
        };

        fixed4 _Color;
        half _SandAmount;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 brickColor = tex2D(_BrickTexture, IN.uv_BrickTexture);
            fixed4 sandColor = tex2D(_SandTexture, IN.uv_SandTexture);

            half brickAlpha = tex2D(_BrickAlphaTexture, IN.uv_BrickAlphaTexture).r;

            fixed4 finalColor = lerp(brickColor, sandColor, _SandAmount);

            finalColor *= _Color;

            o.Alpha = lerp(1.0, brickAlpha, step(_SandAmount, brickAlpha));
            
            o.Albedo = lerp(sandColor.rgb, brickColor.rgb, step(_SandAmount, brickAlpha));
        }
        ENDCG
    }
    FallBack "Diffuse"
}

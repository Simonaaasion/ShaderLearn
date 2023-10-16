Shader "Custom/WaterShader"
{
    Properties
    {
        _MainTint ("Diffuse Tint", color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _SecTex ("Base (RGB)", 2D) = "white" {}
        _ScrollXSpeed ("X Scroll Speed",Range(0,10)) =2
        _ScrollYSpeed ("Y Scroll Speed",Range(0,10)) =1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _MainTint;
        fixed _ScrollXSpeed;
        fixed _ScrollYSpeed;
        sampler2D _MainTex;
        sampler2D _SecTex;


        UNITY_INSTANCING_BUFFER_START(Props)

        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed2 scrolledUV = IN.uv_MainTex;

            fixed xScrollValue = _ScrollXSpeed * _Time;
            fixed yScrollValue = _ScrollYSpeed * (_Time + _CosTime);

            scrolledUV += fixed2(xScrollValue,yScrollValue);
            half4 c2 = tex2D (_SecTex,scrolledUV);
            half4 c1 = tex2D (_MainTex,scrolledUV);
            o.Albedo = (c1.rgb+c2.rgb) * _MainTint;
            o.Alpha = (c1.a+c2.rgb);
        }
        ENDCG
    }
    FallBack "Diffuse"
}

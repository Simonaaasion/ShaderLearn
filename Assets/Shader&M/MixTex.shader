Shader "Custom/MixTex"
{
    Properties
    {
        _MainTint ("Diffuse Tint", Color) = (1, 1, 1, 1)
        _ColorA ("Terrain Color A", Color) = (1,1,1,1)
        _ColorB ("Terrain Color B", Color) = (1,1,1,1)
        _RTex ("Red Channel Tex", 2D) = "" {}
        _GTex ("Green Channel Tex", 2D) = "" {}
        _BTex ("Blue Channel Tex", 2D) = "" {}
        _ATex ("Alpha Channel Tex", 2D) = "" {}
        _BlendTex ("Blend Tex", 2D) = "" {}


    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 5.0

        sampler2D _RTex;
        sampler2D _GTex;
        sampler2D _BTex;
        sampler2D _ATex;
        sampler2D _BlendTex;


        struct Input
        {
            float2 uv_RTex;
            float2 uv_GTex;
            float2 uv_BTex;
            float2 uv_ATex;
            float2 uv_BlendTex;

    
        };

        fixed4 _ColorA;
        fixed4 _ColorB;
        fixed4 _MainTint;


        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 blendData = tex2D(_BlendTex,IN.uv_BlendTex);
            float4 RTexData = tex2D(_RTex,IN.uv_RTex);
            float4 GTexData = tex2D(_GTex,IN.uv_GTex);
            float4 BTexData = tex2D(_BTex,IN.uv_BTex);
            float4 ATexData = tex2D(_ATex,IN.uv_ATex);

            float4 finalColor;
            finalColor = lerp(RTexData,GTexData,blendData.g);
            finalColor = lerp(finalColor,BTexData,blendData.b);
            finalColor = lerp(finalColor,ATexData,blendData.a);
            finalColor.a = 1.0;

            float4 TerrainLayers = lerp(_ColorA,_ColorB,blendData.r);
            finalColor *= TerrainLayers;
            finalColor = saturate(finalColor);

            o.Albedo = finalColor.rgb * _MainTint.rgb;
            o.Alpha = finalColor.a;
        }
            

            

        
        ENDCG
    }
    FallBack "Diffuse"
}

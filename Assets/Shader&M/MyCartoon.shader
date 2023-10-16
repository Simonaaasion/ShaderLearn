Shader "Custom/Cartoon"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _RampTex ("Ramp",Rect) = "white" {}
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NumSteps("Number of Steps", Range(1, 10)) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Toon

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _RampTex;
        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
        fixed _NumSteps;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;

            o.Alpha = c.a;
        }

        /*half4 LightingToon(SurfaceOutput s,fixed3 lightDir,fixed atten)  //贴图 颜色跳变
        {
            float NdotL = dot(s.Normal,lightDir);
            NdotL = tex2D(_RampTex,fixed2(NdotL,0.5));
            fixed4 c;
            c.rgb =s.Albedo * _LightColor0.rgb * (NdotL * atten);
            c.a = s.Alpha;
            return c;
        }*/

        half4 LightingToon(SurfaceOutput s, half3 lightDir, half atten)  // 使用 floor() 函数实现不连续的颜色跳变
        {
            float NdotL = dot(s.Normal, lightDir);
            NdotL = floor(NdotL * _NumSteps) / (_NumSteps-0.5); 
            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

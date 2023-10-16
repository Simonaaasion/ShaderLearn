Shader "Custom/SBoomVert"
{
    Properties
    {
        _RampTex("Color Ramp", 2D) = "White"{}
        _RampOffset("Ramp Offset",Range(-0.5, 0.5)) = 0
        _NoiseTex("Noise tex", 2D) = "Gray" {}
        _Period("Period", Range(0,1)) = 0.5
        _Amount("Amount", Range(0,1)) = 0.1
        _ClipRange("ClipRange", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert noligntmap
        #pragma vertex vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _RampTex;
        half _RampOffset;
        sampler2D _NoiseTex;
        float _Period;
        half _Amount;
        half _ClipRange;

        struct Input
        {
            float2 uv_NoiseTex;
        };

        void vert(inout appdata_full v)
        {
	        float3 disp = tex2Dlod(_NoiseTex, float4(v.texcoord.xy, 0, 0));
	        float time = sin(_Time[3]*_Period+disp.r*10);
	        v.vertex.xyz += v.normal * disp.r * _Amount * time;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
	        float3 noise = tex2D(_NoiseTex, IN.uv_NoiseTex);
	        float n = saturate(noise.r +_RampOffset);
	       // clip(_ClipRange – n);
	        half4 c = tex2D(_RampTex, float2(n, 0.5));
	        o.Albedo = c.rgb;
	        o.Emission = c.rgb * c.a;
        }

        
        ENDCG
    }
    FallBack "Diffuse"
}

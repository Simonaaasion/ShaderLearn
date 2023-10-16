Shader "CookbookShaders/Chapter02/RadiusShader" {
	Properties {
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_CircleTex("Albedo (RGB)", 2D) = "white" {}
		_Center("Center", Vector) = (0,0,0,0)
		_Radius("Radius", Float) = 0.5
		_RadiusWidth("Radius Width", Float) = 2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _CircleTex;
		fixed4 _Color;

		float3 _Center;
		float _Radius;
		float _RadiusWidth;

		struct Input {
			float2 uv_MainTex;
			float2 uv_CircleTex;
			float3 worldPos;
		};

		void surf(Input IN, inout SurfaceOutputStandard o) {
			float d = distance(_Center, IN.worldPos);
			if (d > 0 && d < _Radius + _RadiusWidth)
				o.Albedo = tex2D(_CircleTex,IN.uv_CircleTex).rgb;
			else
				o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}

		
		ENDCG
	} 
	FallBack "Diffuse"
}

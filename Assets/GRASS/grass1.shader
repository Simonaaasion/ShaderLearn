Shader "custom/grass1"
{
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 0)
		_Shininess ("Shininess", Range (0.01, 10)) = 0.078125
		_MainTex ("Base (RGB) TransGloss (A)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5

		_Direction("Direction",Vector) =(0,0,0,0)
		_TimeScale("TimeScale",float) = 1
		_TimeDelay("TimeDelay",float) = 1
	}

	SubShader 
	{
		Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		LOD 400
		Lighting Off
		Cull Off
	
		CGPROGRAM
		#pragma surface surf myLightModel alphatest:_Cutoff vertex:vert
		#pragma target 3.0
	
		sampler2D _MainTex;
		sampler2D _BumpMap;
		fixed4 _Color;
		half _Shininess;
		fixed4 _Direction;
		half _TimeScale;
		half _TimeDelay;

		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};
	    //修改为主要贴图的颜色 
        //lightDir :点到光源的单位向量   viewDir:点到摄像机的单位向量   atten:衰减系数   
        float4 LightingmyLightModel(SurfaceOutput s, float3 lightDir,half3 viewDir, half atten)   
        {   
            float4 c ;   
            c.rgb =  s.Albedo;  
            c.a = s.Alpha;   
            return c;   
        }  

		void vert(inout appdata_full v) 
		{
			fixed4 worldPos =  mul(unity_ObjectToWorld,v.vertex);
			half dis =  v.texcoord.y;
			half time = (_Time.y + _TimeDelay) * _TimeScale;
			v.vertex.xyz += dis * (sin(time + worldPos.x) * cos(time * 2 / 3) + 0.3)* _Direction.xyz;	//核心，动态顶点变换
		} 

		void surf (Input IN, inout SurfaceOutput o) 
		{
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = tex.rgb * _Color.rgb;
			o.Gloss = tex.rgb * _Color.rgb;
			o.Alpha = tex.a * _Color.a;
			o.Specular = _Shininess;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
		}
		ENDCG
	}	
	FallBack "Transparent/Cutout/VertexLit"
}
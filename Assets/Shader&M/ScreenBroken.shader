Shader "Custom/RenderImage/ScreenBroken" {
	Properties {
		_MainTex ("Main Tex", 2D) = "white" {}
		_BrokenNormalMap("BrokenNormal Map",2D)="bump"{}
		_BrokenScale("BrokenScale",Range(0,1))=1.0
	}
	SubShader {
		
 
		Pass{
			Tags { "LightMode"="ForwardBase" }
 
			CGPROGRAM
 
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
 
			#pragma vertex vert
			#pragma fragment frag
 
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BrokenNormalMap;
			float4 _BrokenNormalMap_ST;
			float _BrokenScale;
 
			struct a2v{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};
 
			struct v2f{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
			};
 
			v2f vert(a2v v){
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				
				o.uv.xy=TRANSFORM_TEX(v.texcoord,_MainTex);
				o.uv.zw=TRANSFORM_TEX(v.texcoord, _BrokenNormalMap);
				return o;
			}
 
			fixed4 frag(v2f i) : SV_Target{
 
				fixed4 packedNormal = tex2D(_BrokenNormalMap,i.uv.zw);
				fixed3 tangentNormal;
				tangentNormal=UnpackNormal(packedNormal);
				
				tangentNormal.xy*=_BrokenScale;
				float2 offset = tangentNormal.xy;
 
				fixed3 lightColor = fixed3(1,1,1);
				fixed3 col=tex2D(_MainTex,i.uv.xy+offset).rgb;
				
				fixed luminance = (col.r + col.g + col.b) / 3;
				fixed3 finalCol = lerp(fixed3(luminance,luminance,luminance),col,0.25);
				
				return fixed4(finalCol,1.0f);
			}
			ENDCG
			}
		
		}
	FallBack "Diffuse"
}
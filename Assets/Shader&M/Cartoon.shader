Shader "Unlit/CartoonShader"
{
    Properties
    {
		_DiffuseHighLightCol("DiffuseHighLightCol",COLOR) = (1,1,1,1)
		_DiffuseShadowCol("DiffuseShadowCol",COLOR) = (1,1,1,1)
		_Step("Step" , Range(1,10)) = 3
		_DiffuseSmooth("DiffSmooth" , Range(0,1)) = 0.5

		_SpecularCol("Specular" , COLOR) = (1,1,1,1)
		_Gloss("Gloss",Range(8.0,256)) = 20
		_SpecSmooth("SpecSmooth" , Range(0,1)) = 0.5

		_RimCol("Rim" , COLOR) = (1,1,1,1)
		_RimArea("RimArea" , Range(0,1)) = 0.5
		_RimSmooth("RimSmooth" , Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
	    #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
		float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
		float3 worldNormal : TEXCOORD0;
		float3 worldPos : TEXCOORD1;
            };

			fixed4 _DiffuseHighLightCol;
			float4 _DiffuseShadowCol;
			float _DiffuseSmooth;


			fixed4 _SpecularCol;
			fixed _Gloss;
			float _SpecSmooth;



			float4 _RimCol;
			float _RimArea;
			float _RimSmooth;

			fixed _Step;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldNormal = mul(v.normal, unity_WorldToObject);
				o.worldPos = mul(unity_ObjectToWorld , v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed3 worldPos = (i.worldPos); 
				float3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);  
				fixed3 worldViewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos); 

				float3 halfDir = normalize( worldLightDir + worldViewDir ); 

				float NdotH = max(0 , dot(halfDir , worldNormal));	
				float NdotL = dot(worldNormal , worldLightDir); 
				float NdotV = dot(worldNormal , worldViewDir);

			
				float diff = floor(NdotL * _Step) / _Step ;
				diff = lerp(diff , NdotL , _DiffuseSmooth);
				float4 diffCol = lerp(_DiffuseShadowCol ,_DiffuseHighLightCol, diff);
				fixed3 diffuse = diffCol.rgb * _LightColor0.rgb ;

				fixed3 specular =  pow((NdotH) , _Gloss)* _SpecularCol.rgb;
				specular = smoothstep(0.5 - _SpecSmooth * 0.5, 0.5 + _SpecSmooth * 0.5, specular);

				float rim = (1 - NdotV) * NdotL;
				rim = smoothstep(_RimArea - _RimSmooth * 0.5, _RimArea + _RimSmooth * 0.5, rim);
				float3 rimCol = rim * _RimCol;

				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 ads = diffuse + ambient + specular ;
				fixed4 col = fixed4( ads + rimCol  , 1 );

				return col;
            }
            ENDCG
        }
    }
}
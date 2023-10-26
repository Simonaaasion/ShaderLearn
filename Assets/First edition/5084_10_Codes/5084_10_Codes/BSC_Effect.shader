Shader "Custom/BSC_Effect" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BrightnessAmount ("Brightness Amount", Range(0.0, 2)) = 1.0
		_satAmount ("Saturation Amount", Range(0.0, 2)) = 1.0
		_conAmount ("Contrast Amount", Range(0.0, 3)) = 1.0
		_BlendTex ("Blend Texture", 2D) = "white"{}
		_Opacity ("Blend Opacity", Range(0,1)) = 1
	}
	
	SubShader 
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			
			uniform sampler2D _MainTex;
			half _BrightnessAmount;
			half _satAmount;
			half _conAmount;
			uniform sampler2D _BlendTex;
			fixed _Opacity;
			

			float3 ContrastSaturationBrightness(float3 color, float brt, float sat, float con)
			{
				// Increase or decrease theese values to 
				//adjust r, g and b color channels seperately
				float3 AvgLumin = float3(0.5,0.5,0.5);
				
				//Luminance coefficients for getting lumoinance from the image
				float3 LuminanceCoeff = float3(0.2125, 0.7154, 0.0721);
				
				//Operation for brightness
				float3 brtColor = color * brt;
				float intensityf = dot(brtColor, LuminanceCoeff);
				float3 intensity = float3(intensityf, intensityf, intensityf);
				
				//Operation for Saturation
				float3 satColor = lerp(intensity, brtColor, sat);
				
				//Operation for Contrast

				float3 conColor = lerp(AvgLumin, satColor, con);
				return conColor;
			}

			half4 frag(v2f_img i) : COLOR
			{
				//Get the colors from the RenderTexture and the uv's
				//from the v2f_img struct

				half4 renderTex = tex2D(_MainTex, i.uv);
				fixed4 blendTex = tex2D(_BlendTex, i.uv);

				fixed4 blendedScreen = (1.0 - ((1.0 - renderTex) * (1.0 - blendTex)));
				renderTex = lerp(renderTex, blendedScreen, _Opacity);

				//Apply the Brughtness, saturation, contrast operations
				renderTex.rgb = ContrastSaturationBrightness(renderTex.rgb, 
															_BrightnessAmount, 
															_satAmount, 
															_conAmount);
				
				return renderTex;

			}


	
			ENDCG
		}
	} 
	FallBack off
}

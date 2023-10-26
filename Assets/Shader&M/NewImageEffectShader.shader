Shader "Hidden/NewImageEffectShader"
{
    Properties
    {
        _MainTex("Base(RGB)",2D) = "white"{}
        _LuminosityAmount("GrayScale Amount",Range(0,1)) = 1
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
            half _LuminosityAmount;
            
            half4 frag(v2f_img i):COLOR {
                half4 theTex = tex2D(_MainTex, i.uv);                
                float lumi = 0.299* theTex.r + 0.587* theTex.g + 0.114* theTex.b;
                half4 finalColor = lerp(theTex, lumi, _LuminosityAmount);
                return finalColor;
            }

            ENDCG
        }
    }
}

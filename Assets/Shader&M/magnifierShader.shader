Shader "Custom/Zoom"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            
            sampler2D _MainTex;
            float2 _Pos;
            float _ZoomFactor;
            float _Size;
            
            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            half4 frag (v2f i) : SV_Target
            {
                float2 center = _Pos;
                float2 dir = center - i.uv;
                
                float dis = max(abs(dir.x), abs(dir.y));  
                half atZoomArea = (dis <= _Size * 0.5) ? 1.0 : 0.0;
                
                half4 col = tex2D(_MainTex, i.uv + dir * _ZoomFactor * atZoomArea);
                return col;
            }
            ENDCG
        }
    }
}

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Glass"
{
    Properties
    {
        _NormalMap("Normal Map", 2D) = "bump" {}
        _Distortion("Distortion", Range(0, 100)) = 50
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }

        GrabPass { "_GrabTex" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _GrabTex;
            float4 _GrabTex_TexelSize;
            sampler2D _NormalMap;
            float _Distortion;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 scrPos : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.scrPos = ComputeGrabScreenPos(o.pos);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                float3 bump = UnpackNormal(tex2D(_NormalMap, i.uv));
                float2 offset = bump.xy * _GrabTex_TexelSize.xy * _Distortion;
                fixed4 albedo = tex2D(_GrabTex, (i.scrPos.xy + offset) / i.scrPos.w);
                return albedo;
            }

            ENDCG
        }
    }
}
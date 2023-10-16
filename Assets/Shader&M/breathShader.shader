Shader "Unlit/Breath"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutColor ("OutColor", Color) = (1, 0, 0, 1) //振幅颜色
        _OutDis ("OutDis", Range(0, 1)) = 0.1 //振幅幅度
        _OutTime ("OutTime", Range(0, 10)) = 0.5 //振幅一次的时间
        _AlphaValue ("AlphaValue", Range(0, 0.5)) = 0.1
        _ShowOpen ("ShowOpen", Int) = 0
    }
    SubShader
    {
        Blend SrcAlpha OneMinusSrcAlpha //Blend混合命令
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
        LOD 100

        Pass
        {
            ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            float _OutDis;
            float _OutTime;
            fixed4 _OutColor;
            sampler2D _MainTex;
            float _AlphaValue;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                // 手动计算法线的归一化向量
                float3 normal = normalize(v.normal);
                float2 offset = normal * _OutDis * abs(fmod(_Time.y, _OutTime));
                o.pos.xy += offset;
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.a = 1;
                return col;
            }
            ENDCG
        }
    }
}
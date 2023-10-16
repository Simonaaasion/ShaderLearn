Shader "Custom/Paremid_c6"
{
    Properties
    {
        _MainTex("Texture",2D)="white"{}
        _ExtrusionFactor("Extrusion factor",Range(0,5))=0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma target 5.0
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag
            #pragma multi_compile_fog // make fog work
            #include "UnityCG.cginc"
            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
            struct v2g {
                float4 vertex: SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
            struct g2f {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _ExtrusionFactor;
            v2g vert(a2v v) {
                v2g o;
                o.vertex = v.vertex;
                o.uv = v.uv;
                o.normal = v.normal;
                return o;
            }

            [maxvertexcount(9)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
            {
                g2f o;
                float4 barycenter = (IN[0].vertex + IN[1].vertex + IN[2].vertex) / 3; // 重心
                float3 normal = (IN[0].normal + IN[1].normal + IN[2].normal) / 3;
                for (int i = 0; i < 3; i++) {      // 构成金字塔的三个三角形
                   int next = (i + 1) % 3;           // 计算相邻顶点索引，i=0:1;i=1:2;i=2:0;
                   o.vertex = UnityObjectToClipPos(IN[i].vertex);
                   UNITY_TRANSFER_FOG(o, o.vertex);
                   o.uv = TRANSFORM_TEX(IN[i].uv, _MainTex);
                   o.color = fixed4(0.0,0.0,0.0,1.0);
                   triStream.Append(o);
                   o.vertex = UnityObjectToClipPos(barycenter + float4(normal,0.0) * _ExtrusionFactor);
                   UNITY_TRANSFER_FOG(o, o.vertex); // 金字塔三角形顶尖顶点
                   o.uv = TRANSFORM_TEX(IN[i].uv, _MainTex);
                   o.color = fixed4(1.0,1.0,1.0,1.0);
                   triStream.Append(o);
                   o.vertex = UnityObjectToClipPos(IN[next].vertex);
                   UNITY_TRANSFER_FOG(o, o.vertex);
                   o.uv = TRANSFORM_TEX(IN[i].uv, _MainTex);
                   o.color = fixed4(0.0,0.0,0.0,1.0);
                   triStream.Append(o);
                   triStream.RestartStrip();
                }
            }

            fixed4 frag(g2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv); // 纹理采样    
                UNITY_APPLY_FOG(i.fogCoord, col);   // 应用雾效
                return col;
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
}

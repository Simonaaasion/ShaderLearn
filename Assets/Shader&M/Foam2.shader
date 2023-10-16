Shader "Custom/foams2"
{
    Properties//标记所以外部变量，让该变量按标记显示在编辑器中
    {
        _TintColor      ("Tint Color (RGBA)", Color) = (1,1,1,1)
        _MainTex        ("Texture (RGB)", 2D) = "white" {}
        _Mask           ("Mask", 2D) = "white" {}
        _AlphaDelay     ("Alpha Delay", Range(-1,1)) = 0
        _Speed          ("Time Scale", Range(0,1)) = 0.25
        _WaveRange      ("Wave Range", Range(-1,1)) = 0.6
        _Layer1OffsetX  ("Layer1 Offset X", Range(-2,2)) = 0
        _Layer2OffsetX  ("Layer2 Offset X", Range(-2,2)) = 0
        _Layer3OffsetX  ("Layer3 Offset X", Range(-2,2)) = 0
        _Layer1OffsetY  ("Layer1 Offset Y", Range(-2,2)) = 0
        _Layer2OffsetY  ("Layer2 Offset Y", Range(-2,2)) = 0
        _Layer3OffsetY  ("Layer3 Offset Y",Range(-2,2)) = 0

    }
    SubShader
    {
        Tags 
        { 
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }
        LOD 100

        Pass
        {
            ZWrite off
            Blend srcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert     //顶点着色器 类似于宏定义，告诉Unity这个函数名是顶点做色器函数
            #pragma fragment frag   //片段着色器

            #include "UnityCG.cginc" //类似头文件？主要是Untiy提供的一些常用函数 貌似不写编译时也会自动包含进来

            //顶点着色器输入结构体
            struct appdata
            {
                float4 vertex : POSITION;   //POSITION输入语义，Unity将顶点坐标提交于此变量
                float4 uv : TEXCOORD0;      //TEXCOORD0，Unity将模型第一套UV提交于此变量
            };

            //顶点着色器输出结构体 （反正会给片段做色器使用）
            struct v2f
            {
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;//输出语义
                float4 uv1 : TEXCOORD0;
                float4 uv2 : TEXCOORD1;
                float4 uv3 : TEXCOORD2;
                float2 uv4 : TEXCOORD3;
            };

            //外部变量声明
            uniform sampler2D   _MainTex;
            uniform float4      _MainTex_ST;
            uniform sampler2D   _Mask;
            uniform float4      _Mask_ST;
            uniform half4       _TintColor;
            uniform float       _AlphaDelay;
            uniform float       _Speed;
            uniform float       _WaveRange;
            uniform float       _Layer1OffsetX;
            uniform float       _Layer2OffsetX;
            uniform float       _Layer3OffsetX;
            uniform float       _Layer1OffsetY;
            uniform float       _Layer2OffsetY;
            uniform float       _Layer3OffsetY;

            //UV动画函数
            float2 DelayOffsetUV(float2 uv, float offset, float offset_y)//输入UV 和偏移量（x，y），外部变量控制速度，范围
            {
                float pi = 3.1415926536f;
                float sintime = sin(_Time.y * _Speed * pi + offset * 0.5f * pi);//余弦函数使UV来回移动,
                float u = (sintime + 1) * 0.5f * _WaveRange + (1 - _WaveRange);
                uv.x += u;
                uv.y += offset_y;
                return uv;
            }

            //顶点着色器
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                //逐层偏移
                float2 inuv = v.uv;
                // layer1 uv offset 
                float2 uv_tex1 = DelayOffsetUV(inuv, _Layer1OffsetX, _Layer1OffsetY);
                o.uv1.xy = TRANSFORM_TEX(uv_tex1, _MainTex);

                // layer1 uv offset 
                float2 uv_tex2 = DelayOffsetUV(inuv, _Layer2OffsetX, _Layer2OffsetY);
                o.uv1.zw = TRANSFORM_TEX(uv_tex2, _MainTex);

                // layer1 uv offset 
                float2 uv_tex3 = DelayOffsetUV(inuv, _Layer3OffsetX, _Layer3OffsetY);
                o.uv2.xy = TRANSFORM_TEX(uv_tex3, _MainTex);



                //每一层的Mask（透贴）偏移，偏移量与tex一致，并可以用_AlphaDelay微调
                // mask1 uv offset
                float2 uv_mask1 = DelayOffsetUV(inuv, _Layer1OffsetX - _AlphaDelay, _Layer1OffsetY);
                o.uv2.zw = TRANSFORM_TEX(uv_mask1, _Mask);

                // mask2 uv offset
                float2 uv_mask2 = DelayOffsetUV(inuv, _Layer2OffsetX - _AlphaDelay, _Layer2OffsetY);
                o.uv3.xy = TRANSFORM_TEX(uv_mask2, _Mask);

                // mask3 uv offset
                float2 uv_mask3 = DelayOffsetUV(inuv, _Layer3OffsetX - _AlphaDelay, _Layer3OffsetY);
                o.uv3.zw = TRANSFORM_TEX(uv_mask3, _Mask);

                UNITY_TRANSFER_FOG(o,o.vertex);

                o.uv4 = inuv;
                return o;
            }

            //获取泡沫逐渐出现，向岸边移动，开始折返并逐渐消失的透明度值
            fixed GetDisappearAlpha(float delay)
            {
                float PI = 3.1415926536f;
                float t = _Time.y *_Speed * PI + delay * 0.5* PI + 1.2 * PI;
                fixed a = (sin(t)+1)*0.5;
                return a*a; 
            }

            //将两层半透明的颜色合并，获取合并后的RGBA
            fixed4 TwoColorBlend(fixed4 c1, fixed4 c2)
            {
                fixed4 c12;
                c12.a = c1.a + c2.a - c1.a * c2.a;
                c12.rgb = (c1.rgb * c1.a * (1 - c2.a) + c2.rgb * c2.a) / c12.a;
                return c12;
            }

            //片段着色器
            fixed4 frag(v2f i) : SV_Target //参数为输入结构体，语义就是输出到什么地方
            {
                fixed pi = 3.1415926536f;

                //get rgb
                fixed4 c1 = tex2D(_MainTex, i.uv1.xy);
                fixed4 c2 = tex2D(_MainTex, i.uv1.zw);
                fixed4 c3 = tex2D(_MainTex, i.uv2.xy);

                //get alpha
                c1.a = tex2D(_Mask, i.uv2.zw) * GetDisappearAlpha(_Layer1OffsetX);
                c2.a = tex2D(_Mask, i.uv3.xy) * GetDisappearAlpha(_Layer2OffsetX);
                c3.a = tex2D(_Mask, i.uv3.zw) * GetDisappearAlpha(_Layer3OffsetX);

                //layer1 + layer2
                fixed4 c12 = TwoColorBlend(c1,c2);
                //layer12 + layer3
                fixed4 c123 = TwoColorBlend(c12,c3);

                return c123 * _TintColor;
            }
            ENDCG
        }
    }
}

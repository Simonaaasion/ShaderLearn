Shader "MyShader/MotionBlur" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {} // ������
        _BlurAmount ("Blur Amount", Float) = 1.0 // ģ��ֵ, ͨ��alphaͨ�����Ƶ�ǰ��Ļ��������ʷ��Ļ������л��
    }

    SubShader {
        CGINCLUDE

        #include "UnityCG.cginc"
        
        sampler2D _MainTex; // ������
        fixed _BlurAmount; // ģ��ֵ, ͨ��alphaͨ�����Ƶ�ǰ��Ļ��������ʷ��Ļ������л��

        fixed4 fragRGB (v2f_img i) : SV_Target { // v2f_imgΪ���ýṹ��, ����ֻ����pos��uv
            return fixed4(tex2D(_MainTex, i.uv).rgb, _BlurAmount);
        }

        half4 fragA (v2f_img i) : SV_Target { // v2f_imgΪ���ýṹ��, ����ֻ����pos��uv
            return tex2D(_MainTex, i.uv);
        }

        ENDCG

        ZTest Always Cull Off ZWrite Off

        Pass {
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask RGB // ����ͨ������ɫͨ��, ȡֵ��: 0��R��G��B��A��RGBA�����(RG��RGB��)

            CGPROGRAM

            #pragma vertex vert_img // ʹ�����õ�vert_img������ɫ��
            #pragma fragment fragRGB // _BlurAmountֻ������, ��Ӱ��alphaֵ

            ENDCG
        }

        Pass {
            Blend One Zero
            ColorMask A // ����ͨ������ɫͨ��, ȡֵ��: 0��R��G��B��A��RGBA�����(RG��RGB��)

            CGPROGRAM

            #pragma vertex vert_img // ʹ�����õ�vert_img������ɫ��
            #pragma fragment fragA // ʹ������ԭ����alphaֵ

            ENDCG
        }
    }

    FallBack Off
}
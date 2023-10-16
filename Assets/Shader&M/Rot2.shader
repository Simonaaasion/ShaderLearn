Shader "Custom/Rot2"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _RotationSpeed ("Rotation Speed", Range(0, 10)) = 2
    }
    SubShader
    {
     Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        float _RotationSpeed;

        void vert(inout appdata_full v)
        {
            // No vertex transformation needed
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float2 center = 0.5;
            float2 uv = IN.uv_MainTex - center;
            float len = length(uv);
            float angle = len * _RotationSpeed * _Time.y;
            float2x2 rotationMatrix = float2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
            uv = mul(rotationMatrix, uv);
            uv += center;
            half4 c = tex2D(_MainTex, uv);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
//UV位置变换Shader
//实现纹理绕中心点旋转
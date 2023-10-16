Shader "Custom/So"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Amount("Extrusion Amount",Range(-0.0001,0.0001)) = 0
        _ExtrusionTex ("Normal", 2D) = "white" {}
        _UserTex("User Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert 
        #pragma vertex vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _ExtrusionTex;
        sampler2D _UserTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_ExtrusionTex;
            float2 uv_UserTex;

        };
        fixed4 _Color;

        float _Amount;



        void vert(inout appdata_full v)
        {
	        float4 tex = tex2Dlod(_ExtrusionTex, float4(v.texcoord.xy, 0, 0));
            float extrusion = tex.r * 2 - 1;
            float4 userTex = tex2Dlod(_UserTex, v.texcoord.xyzw);
            float userExtrusion = userTex.r * 2 - 1;
	        v.vertex.xyz += v.normal * _Amount * extrusion * userExtrusion;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 normalMap = UnpackNormal(tex2D(_ExtrusionTex,IN.uv_ExtrusionTex));
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Normal = normalMap.rgb;
        }
        
        
        ENDCG
    }
    FallBack "Diffuse"
}

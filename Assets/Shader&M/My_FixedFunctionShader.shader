Shader "Custom/NewSurfaceShader"
{
    Properties
    {
        _MyColor ("ChooseColor", color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _transparency ("Transparency", range(0,1)) = 0.0
        
        
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        struct Input
        {
            float2 uv_MainTex;
        };

        half _transparency;
        fixed4 _MyColor;
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = _MyColor;
            o.Albedo = c.rgb;

                
            o.Alpha = c.a;
            o.Occlusion = _transparency;
        }
        ENDCG
    }

    FallBack "Diffuse"
}

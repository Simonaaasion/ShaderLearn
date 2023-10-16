Shader "Custom/ExplosionShader" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _ExplosionCenter ("Explosion Center", Vector) = (0, 0, 0, 0)
        _ExplosionForce ("Explosion Force", Range(0, 10)) = 5
        _ExplosionRadius ("Explosion Radius", Range(0, 10)) = 2
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        float4 _ExplosionCenter;
        float _ExplosionForce;
        float _ExplosionRadius;

        struct Input {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o) {
            float4 worldPos = mul(unity_ObjectToWorld, float4(IN.uv_MainTex, 0, 1));
            float dist = distance(worldPos.xyz, _ExplosionCenter.xyz);
            if (dist <= _ExplosionRadius) {
                float3 direction = normalize(worldPos.xyz - _ExplosionCenter.xyz);
                o.Albedo = float3(1, 0, 0); // 爆炸时的颜色
                o.Normal = direction;
                o.Alpha = 0; // 让爆炸部分透明
                o.Specular = 0; // 没有高光
                o.Emission = 1; // 发光效果
                float explosionStrength = (_ExplosionRadius - dist) * _ExplosionForce;
                worldPos.xyz += direction * explosionStrength;
            }
            else {
                o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
                o.Normal = float3(0, 0, 1);
                o.Alpha = 1;
                o.Specular = 0.5;
                o.Emission = 0;
            }

            // 将修改后的世界坐标转换回对象空间坐标
            IN.uv_MainTex = (mul(unity_WorldToObject, worldPos)).xy;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
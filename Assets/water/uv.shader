
// 运动的水波
Shader "water/uv"
{
    Properties
    {
        _MainTex("texture",2D)="white"{}
        _SubTex("texture",2D)="white"{}
        _Speed("uv speed",Range(0,1))=0.1

    }
    SubShader
    {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex:POSITION;
                float4 uv:TEXCOORD0;
            };
            struct v2f {
                float2 uv:TEXCOORD0;
                float4 vertex:SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _SubTex;
            float4 _SubTex_ST;
            float _Speed;

            v2f vert(appdata v) {
                v2f o;
                
                o.vertex =  UnityObjectToClipPos(v.vertex);
                
                // 这个里面需要_ST  所以上面必须定义
                // 根据顶点的纹理坐标，计算出对应纹理真正的 UV 坐标
                o.uv = TRANSFORM_TEX( v.uv,_MainTex);
                return o;
            };

            // : SV_TARGET 一定要记得写这个。。。
            fixed4 frag(v2f f): SV_TARGET {

                float2 uv_offset = float2(0,0);

                uv_offset.x = _Time.y * _Speed;
                uv_offset.y = _Time.y * _Speed;

                fixed4 lightColor = tex2D(_SubTex,f.uv + uv_offset);
                
                fixed4 textureColor = tex2D(_MainTex,f.uv);
                // fixed4 textureColor = fixed4(1,1,0,1);
                return textureColor + lightColor;
            };
            ENDCG
        }
        
    }
    FallBack "Diffuse"
}


// 运动的水波
Shader "water/water"
{
    Properties
    {
        _MainTex("texture",2D)="white"{}
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

            v2f vert(appdata v) {
                v2f o;
                
                // 计算每一个顶点到中心的距离
                float _distance = distance(v.vertex.xyz,float3(0,0,0));

                // 根据时间对每个顶点做正弦变化
                float h = sin(_distance + _Time.z) / 4;

                // 把顶点从物体转回到世界中，
                o.vertex =  mul(unity_ObjectToWorld, v.vertex)  ;
                // 垂直方向上变化
                o.vertex.y = h;
                // 从世界变化到裁剪坐标
                o.vertex =  UnityObjectToClipPos(o.vertex);
                
                // 这个里面需要_ST  所以上面必须定义
                // 根据顶点的纹理坐标，计算出对应纹理真正的 UV 坐标
                o.uv = TRANSFORM_TEX( v.uv,_MainTex);
                return o;
            };

            // : SV_TARGET 一定要记得写这个。。。
            fixed4 frag(v2f f): SV_TARGET {
                
                fixed4 textureColor = tex2D(_MainTex,f.uv.xy);
                return textureColor;
            };


            ENDCG
        }
        
    }
    FallBack "Diffuse"
}

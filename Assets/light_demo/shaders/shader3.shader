// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// 漫反射 demo

Shader "light_demo/m3"
{


    SubShader 
    {
        Pass {
            CGPROGRAM
            
            #include "Lighting.cginc"

            // 顶点函数，作用是完成顶点坐标从模型空间到裁剪空间的转换（从游戏环境转换到屏幕环境） 
            #pragma vertex vertex
            // 片元函数，作用是返回模型对应的屏幕上每一个像素的颜色值
            #pragma fragment frag


            // **  important!!! 下面的都必须在结尾写分号，坑*******
            struct a2v {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };

            struct v2f {
                float4 pos:SV_POSITION;
                float3 temp:COLOR;
            };
            
            v2f vertex(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                // 直接将法线变量作为颜色值，让 unity 自己做插值运算，就形成了那个渐变的感觉
                o.temp = v.normal;
                return o;
            }

            
            fixed4 frag(v2f f):SV_TARGET {
                return fixed4(f.temp,1);
            }
            ENDCG
        }
    }
    
    Fallback "Diffuse"
}

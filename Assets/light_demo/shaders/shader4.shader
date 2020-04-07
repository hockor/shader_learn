// 漫反射 demo （逐顶点光照）

Shader "light_demo/m4"
{

    Properties {

        _Diffuse("diffuse color",COLOR)= (1,1,1,1)
    }
    SubShader 
    {
        Pass {
            Tags {"LightMode"="ForwardBase"}
            CGPROGRAM
            
            #include "Lighting.cginc"

            // 顶点函数，作用是完成顶点坐标从模型空间到裁剪空间的转换（从游戏环境转换到屏幕环境） 
            #pragma vertex vertex
            // 片元函数，作用是返回模型对应的屏幕上每一个像素的颜色值
            #pragma fragment frag

            fixed4 _Diffuse;

            // **  important!!! 下面的都必须在结尾写分号，坑*******
            struct a2v {
                float4 vertex:POSITION; // 告诉 unity 把模型空间下的顶点坐标给 vertex
                float3 normal:NORMAL; // 告诉 unity 把模型空间下的法线方向给 normal
            };

            struct v2f {
                float3 normal:NORMAL; 
                float4 pos:SV_POSITION;
                fixed3 color:COLOR;
            };
            
            
            v2f vertex(a2v v) {
                v2f o;
                // 让模型顶点数据坐标从本地坐标转化为屏幕剪裁坐标  
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                // 返回环境光和漫反射光的相加
                
                return o;
            }
            
            fixed4 frag(v2f f):SV_TARGET {
                // 获取环境光，
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                // 计算世界法线方向
                fixed3 worldNormal = UnityObjectToWorldNormal(f.normal);
                // 计算灯光方向  
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

                // 计算漫反色  和传入的颜色进行融合
                fixed3 diffuse = _LightColor0.rgb *_Diffuse.rgb * saturate(dot(worldNormal, worldLight));
                fixed3 tempColor = ambient + diffuse;
                return fixed4(tempColor,1);
            }
            ENDCG
        }
    }
    
    Fallback "Diffuse"
}

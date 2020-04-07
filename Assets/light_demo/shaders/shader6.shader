// 高光反射 demo 
//  specular = 直射光 * pow(cosα，高光的系数x) α是反射光方向和视野方向的夹角
Shader "light_demo/m6"
{

    Properties {

        _Diffuse("diffuse color",COLOR)= (1,1,1,1)
        _Gloss("gloss size",Range(2,40)) = 10
        _SpecularColor("specular color",COLOR)=(1,1,1,1)
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
            half _Gloss;
            fixed4 _SpecularColor;

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
                
                
                // 获取环境光，
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                // 计算世界法线方向
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                // 计算灯光方向  
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

                // 计算漫反色  和传入的颜色进行融合
                fixed3 diffuse = _LightColor0.rgb *_Diffuse.rgb * saturate(dot(worldNormal, worldLight));

                // 计算高光
                // 这里worldLight要用反方向的，不然的话亮斑会在背面。。
                fixed3 reflectDir = normalize(reflect(-worldLight,worldNormal));
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(v.vertex,unity_WorldToObject).xyz);
                // 不适用环境光，适用自己定义的颜色
                fixed3 specular = _SpecularColor * pow(max(dot(reflectDir,viewDir),0),_Gloss);

                o.color = ambient + diffuse + specular;
                return o;
            }
            
            fixed4 frag(v2f f):SV_TARGET {
                
                return fixed4(f.color,1);
            }
            ENDCG
        }
    }
    
    Fallback "Diffuse"
}

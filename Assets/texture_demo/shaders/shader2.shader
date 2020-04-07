
Shader "texture_demo/m2"
{

    Properties {

        _MainTex("texture",2D)="white"{}
        _Gloss("gloss size",Range(2,40)) = 10
        _SpecularColor("specular color",COLOR)=(1,1,1,1)
    }
    SubShader 
    {
        Pass {
            Tags {"LightMode"="ForwardBase"}
            CGPROGRAM
            
            #include "Lighting.cginc"
            #include "UnityCG.cginc"
            // 顶点函数，作用是完成顶点坐标从模型空间到裁剪空间的转换（从游戏环境转换到屏幕环境） 
            #pragma vertex vertex
            // 片元函数，作用是返回模型对应的屏幕上每一个像素的颜色值
            #pragma fragment frag

            
            half _Gloss;
            fixed4 _SpecularColor;
            fixed4 _Color;
            sampler2D _MainTex;

            struct a2v {
                float4 vertex:POSITION; // 告诉 unity 把模型空间下的顶点坐标给 vertex
                float3 normal:NORMAL; // 告诉 unity 把模型空间下的法线方向给 normal
                float4 texcoord:TEXCOORD0;
            };

            struct v2f {
                float3 normal:NORMAL; 
                float4 pos:SV_POSITION;
                fixed3 color:COLOR;
                fixed3 view:TEXCOORD;
                float4 uv:TEXCOORD1;
            };
            
            
            v2f vertex(a2v v) {
                v2f o;
                // 让模型顶点数据坐标从本地坐标转化为屏幕剪裁坐标  
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.uv = v.texcoord;
                o.view = _WorldSpaceCameraPos.xyz - mul(v.vertex,unity_WorldToObject).xyz;
                return o;
            }
            
            fixed4 frag(v2f f):SV_TARGET {
                
                // 获取环境光，
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                // 获取纹理坐标对应的颜色
                float3 textureColor = tex2D(_MainTex,f.uv.xy);
                // 计算世界法线方向
                fixed3 worldNormal = UnityObjectToWorldNormal(f.normal);
                // 计算灯光方向  
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

                // 计算漫反色  和传入的颜色进行融合
                fixed3 diffuse = _LightColor0.rgb * textureColor * saturate(dot(worldNormal, worldLight));
                // 计算高光
                fixed3 reflectDir = normalize(reflect(-worldLight,worldNormal));
                fixed3 viewDir = normalize(f.view);

                fixed3 halfDir = normalize(viewDir + worldLight);
                fixed3 specular = _SpecularColor * pow(max(dot(reflectDir,halfDir),0),_Gloss);
                fixed3 tempColor = ambient + diffuse + specular;
                return fixed4(tempColor,1);
            }
            ENDCG
        }
    }
    
    Fallback "Diffuse"
}

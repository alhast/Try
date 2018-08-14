// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/34" {
Properties {
     [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
     _Color ("Left Color", Color) = (1,1,1,1)
     _Color2 ("Right Color", Color) = (1,1,1,1)
}
SubShader {
     Tags {"Queue"="Transparent"  "IgnoreProjector"="False"}
	  Tags { "RenderType" = "Opaque"}
     LOD 100
     ZWrite Off
     Pass {
	  Tags {"LightMode" = "ForwardBase"}
          Blend SrcAlpha OneMinusSrcAlpha
         CGPROGRAM

		 #include "AutoLight.cginc"
         #pragma vertex vert
         #pragma fragment frag
         #include "UnityCG.cginc"
         fixed4 _Color;
         fixed4 _Color2;
         struct v2f {
             float4 pos : SV_POSITION;
             fixed4 col : COLOR;
			    float3 lightDir : TEXCOORD1;
 
                    float3 vNormal : TEXCOORD2;
 
                    LIGHTING_COORDS(3,4)
         };
         v2f vert (appdata_full v)
         {
             v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
 
                    
 
                    // Calc normal and light dir.
 
                    o.lightDir = normalize(ObjSpaceLightDir(v.vertex));
 
                    o.vNormal = normalize(v.normal).xyz;
 
                    
 
                    // Calc spherical harmonics and vertex lights. Ripped from compiled surface shader.
 
                    float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
 
                    float3 worldNormal = mul((float3x3)unity_ObjectToWorld, SCALED_NORMAL);
 
 
                    #ifdef LIGHTMAP_OFF
 
                        float3 shlight = ShadeSH9(float4(worldNormal, 1.0));
 
                      
 
                        #ifdef VERTEXLIGHT_ON
 
                            o.vlight += Shade4PointLights (
 
                                unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
 
                                unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
 
                                unity_4LightAtten0, worldPos, worldNormal
 
                                );
 
                        #endif // VERTEXLIGHT_ON
 
                    #endif // LIGHTMAP_OFF
 
                
 
                    TRANSFER_VERTEX_TO_FRAGMENT(o);
             o.pos = UnityObjectToClipPos (v.vertex);
             o.col = lerp(_Color,_Color2, v.texcoord.y );
             return o;
         }
   
         float4 frag (v2f i) : COLOR {

             float4 c = i.col;
			 float atten = LIGHT_ATTENUATION(i);
             return c;
         }
             ENDCG
         }
     }
}
Shader "MyShader/PP_Outlines"
{
    Properties
    {
        [HideInInspector]
        _MainTex ("Texture", 2D) = "white" {}
        _NormalMult ("Normal Outline Multiplier",Range(0,10)) = 1
        _NormalBias ("Normal outline Bias",Range(1,4)) = 1
        _DepthMult ("Depth Outline Multiplier",Range(0,10)) = 1
        _DepthBias ("Depth Outline Bias",Range(1,4)) = 1

        _OutlineColor ("Outline Color",Color) = (0,0,0,1)
        
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;             
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;
            // the depth normals texture
            sampler2D _CameraDepthNormalsTexture;
            // texelsize of the depthNormals texture
            float4 _CameraDepthNormalsTexture_TexelSize;

            float _NormalMult;
            float _NormalBias;
            float _DepthMult;
            float _DepthBias;
            
            float4 _OutlineColor;

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            // depth ouline version
            //float ComparePixelAround(float baseDepth,float2 uv,float2 offset)
            //{
            //    // read neighbor pixel
            //    float4 neighborDepthNormal = tex2D(_CameraDepthNormalsTexture, uv + _CameraDepthNormalsTexture_TexelSize.xy * offset);

            //    float3 neighborNormal;
            //    float neighborDepth;
            //    DecodeDepthNormal(neighborDepthNormal,neighborDepth,neighborNormal);

            //    neighborDepth *= _ProjectionParams.z;

            //    return baseDepth - neighborDepth;
            //}


            //depth and normal outline version
            void ComparePixelAround(inout float depthOutline, inout float normalOutline,
                                    float baseDepth ,float3 baseNormal,float2 uv,float2 offset)
            {
                // read neighbor pixel
                float4 neighborDepthNormal = tex2D(_CameraDepthNormalsTexture, uv + _CameraDepthNormalsTexture_TexelSize.xy * offset);

                float3 neighborNormal;
                float neighborDepth;
                DecodeDepthNormal(neighborDepthNormal,neighborDepth,neighborNormal);

                neighborDepth *= _ProjectionParams.z;

                float depthDifference = baseDepth - neighborDepth;;
                depthOutline +=depthDifference;

                float3 normalDifference = baseNormal - neighborNormal;
                normalDifference = normalDifference.r + normalDifference.g + normalDifference.b;
                normalOutline += normalDifference;
            }

            float4 frag (v2f i) : SV_Target
            {
               
                float4 depthNormal = tex2D(_CameraDepthNormalsTexture,i.uv);

                float3 normal;
                float depth;

                DecodeDepthNormal(depthNormal,depth,normal);

                depth *= _ProjectionParams.z;

               
                
                //float depthDifference = ComparePixelAround(depth,i.uv,float2(1,0));
                //depthDifference += ComparePixelAround(depth,i.uv,float2(-1,0));
                //depthDifference += ComparePixelAround(depth,i.uv,float2(0,1));
                //depthDifference += ComparePixelAround(depth,i.uv,float2(0,-1));

                float depthDifference = 0;
                float normalDifference = 0;

                ComparePixelAround(depthDifference, normalDifference, depth, normal, i.uv, float2(1, 0));
                ComparePixelAround(depthDifference, normalDifference, depth, normal, i.uv, float2(-1, 0));
                ComparePixelAround(depthDifference, normalDifference, depth, normal, i.uv, float2(0, 1));
                ComparePixelAround(depthDifference, normalDifference, depth, normal, i.uv, float2(0, -1));

                depthDifference *= _DepthMult;
                depthDifference = saturate(depthDifference);
                depthDifference = pow(depthDifference,_DepthBias);

                normalDifference *= _NormalMult;
                normalDifference = saturate(normalDifference);
                normalDifference = pow(normalDifference,_NormalBias);

                float outline = depthDifference + normalDifference;

                float4 sourceColor = tex2D(_MainTex,i.uv);
                float4 finalColor = lerp(sourceColor,_OutlineColor,outline);

                return finalColor;
            }
            ENDCG
        }
    }
}

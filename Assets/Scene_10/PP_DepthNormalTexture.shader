Shader "MyShader/PP_DepthNormalTexture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _UpCutoff("UpCutoff",Range(0,1)) = 0.5
        _UpColor("UpColor",Color) = (1,1,1,1)
        
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
            sampler2D _CameraDepthNormalsTexture;

            float4x4 _ViewToWorldMatrix;
            float _UpCutoff;
            float4 _UpColor;

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
               
               float4 depthNormal = tex2D(_CameraDepthNormalsTexture,i.uv);

               float3 normal;
               float depth;
               DecodeDepthNormal(depthNormal,depth,normal);
               depth *= _ProjectionParams.z;

               normal = mul((float3x3)_ViewToWorldMatrix,normal);


               float up = dot(float3(0,1,0),normal);
               up = step(_UpCutoff,up);
               float4 source = tex2D(_MainTex,i.uv);
               
               float4 finalCol = lerp(source,_UpColor,up * _UpColor.a);
               return finalCol;
               
            }
            ENDCG
        }
    }
}

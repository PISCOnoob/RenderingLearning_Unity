Shader "MyShader/PP_DepthTexture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [Header(Wave)]
        _WaveDistance ("Distance from player",float) = 20
        _WaveWidth ("Length of the trail",Range(0,5)) = 1
        _WaveColor ("Color",Color) = (1,0,1,1)
        
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
            sampler2D _CameraDepthTexture;
            float _WaveDistance;
            float _WaveWidth;
            float4 _WaveColor;

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
               
               float depth = tex2D(_CameraDepthTexture,i.uv).r;
               
               depth = Linear01Depth(depth);
               depth *= _ProjectionParams.z;

               float4 source = tex2D(_MainTex,i.uv);
               
               if(depth>=_ProjectionParams.z)
               {
                   return source;
               }

               // calculate wave
               float waveFront = step(depth,_WaveDistance); 

               float waveRear = smoothstep(_WaveDistance - _WaveWidth,_WaveDistance,depth);

               float wave = waveFront * waveRear;

               float4 finalCol = lerp(source,_WaveColor,wave);
             
               return finalCol;
            }
            ENDCG
        }
    }
}

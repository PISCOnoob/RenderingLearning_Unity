Shader "MyShader/Boxblur"
{
    Properties
    {
        [HideInInspector]
        _MainTex ("Texture", 2D) = "white" {}
        _BlurIntensity  ("Blur Intensity x",range(0.0,0.05))=0.0
 
        [KeywordEnum(Low,Medium,High)]_Sample ("Sample amount",float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        // y axis blur
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _SAMPLE_LOW _SAMPLE_MEDIUM _SAMPLE_HIGH

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
            //float4 _MainTex_ST;     //for tilling and offset
            float _BlurIntensity;
            float _Sample;

            #if _SAMPLE_LOW
                #define SAMPLES 10
            #elif _SAMPLE_MEDIUM
                #define SAMPLES 50
            #else
                #define SAMPLES 100
            #endif

            

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                _Sample = SAMPLES;
               float4 finalCol = 0;
               // iterate over blur samples
               for(float index = 0;index<SAMPLES;index++)
               {
                    // get uv of sample
                    float2 uv = i.uv + float2(0,(index/(SAMPLES-1) - 0.5) * _BlurIntensity);
                    // add color at position to color
                    finalCol += tex2D(_MainTex,uv);
               }          
               finalCol = finalCol/SAMPLES;
               return finalCol;
            }
            ENDCG
        }
        // x axis blur
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _SAMPLE_LOW _SAMPLE_MEDIUM _SAMPLE_HIGH

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
            //float4 _MainTex_ST;     //for tilling and offset
            float _BlurIntensity;
            float _Sample;

            #if _SAMPLE_LOW
                #define SAMPLES 10
            #elif _SAMPLE_MEDIUM
                #define SAMPLES 50
            #else
                #define SAMPLES 100
            #endif

            

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                _Sample =SAMPLES;
                float invertAspect = _ScreenParams.y / _ScreenParams.x; 
               float4 finalCol = 0;
               // iterate over blur samples
               for(float index = 0;index<SAMPLES;index++)
               {
                    // get uv of sample
                    float2 uv = i.uv + float2((index/(SAMPLES - 1) - 0.5) * _BlurIntensity * invertAspect,0);
                    // add color at position to color
                    finalCol += tex2D(_MainTex,uv);
               }          
               finalCol = finalCol/SAMPLES;
               return finalCol;
            }
            ENDCG
        }
    }
}

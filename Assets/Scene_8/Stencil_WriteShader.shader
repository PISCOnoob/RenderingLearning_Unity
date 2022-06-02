Shader "MyShader/Stencil_WriteShader"
{
    Properties
    {
        [IntRange]
        _StencilBufferRef("Stencil Ref",Range(0,255)) = 0
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque"
            "Queue"="Geometry-1"
            }
        LOD 100
        ColorMask 0

        Stencil
        {
            Ref [_StencilBufferRef]
            Comp Always
            pass Replace
        }

        Pass
        {
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _StencilBufferRef;

            struct a2v
            {
                float4 vertex : POSITION;
                //float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                //float2 uv : TEXCOORD0;             
                float4 pos : SV_POSITION;
            };

            

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);               
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
               

                return 0;
            }
            ENDCG
        }
    }
}

Shader "MyShader/ColorLinearInterpolation"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
        _FirstCol ("FirstCol",Color) = (1,1,1,1)
        _SecondCol ("SecondCol",Color) = (1,1,1,1)
        _Tex0 ("Tex0",2D) = "white"{}
        _Tex1 ("Tex1",2D) = "white"{}
         
        _Blend ("Blend Value",Range(0,1)) = 0
        _WeightTex("WeightTex",2D) = "white"{}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _FirstCol;
            float4 _SecondCol;
            sampler2D _Tex0;
            sampler2D _Tex1;
            sampler2D _WeightTex;
            float _Blend;
            struct a2v
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;             
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;     //for tilling and offset

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {              
                //float4 finalCol = _FirstCol * (1-_Blend) + _SecondCol * _Blend;
                float4 tex0 = tex2D(_Tex0,i.uv);
                float4 tex1 = tex2D(_Tex1,i.uv);

                float4 weight = tex2D(_WeightTex,i.uv);
                float4 finalCol = lerp(tex0,tex1,weight);
                return finalCol;
            }
            ENDCG
        }
    }
}

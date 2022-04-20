Shader "MyShader/LerpBlendTex"
{
    Properties
    {
        _Tex0 ("Tex0", 2D) = "white" {}
        _Tex1 ("Tex1",2D) = "white" {}
        _BlendWeight ("WeightTex",2D) = "white" {}
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

            sampler2D _Tex0;
            float4 _Tex0_ST;     //for tilling and offset
            sampler2D _Tex1;
            sampler2D _BlendWeight;

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = v.uv;//TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
               float4 tex0 = tex2D(_Tex0,i.uv);
               float4 tex1 = tex2D(_Tex1,i.uv);
               // actually we can us different tex to control the effect
               float4 weight = tex2D(_BlendWeight,i.uv);

               float4 finalCol = lerp(tex0,tex1,weight);
                return finalCol;
            }
            ENDCG
        }
    }
}

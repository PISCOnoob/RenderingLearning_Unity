Shader "MyShader/GrayScale"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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

            sampler2D _MainTex;
            float4 _MainTex_ST;     //for tilling and offset

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 GrayScale(float4 tex)
            {
                float grayScale = tex.r * 0.299 + tex.g * 0.587 + tex.b * 0.114;
                return float4(grayScale,grayScale,grayScale,tex.a);
            }
            float4 frag (v2f i) : SV_Target
            {
               
                float4 finalCol = tex2D(_MainTex,i.uv);
                finalCol = GrayScale(finalCol);
                return finalCol;
            }
            ENDCG
        }
    }
}

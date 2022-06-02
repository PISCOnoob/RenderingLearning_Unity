Shader "MyShader/GaussianBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Offset  ("Offset",range(0.0,1.0))=0.0
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
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;             
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;     //for tilling and offset
            float _Offset;

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
               // it is expensive to sample 3 times

                float4 finalCol = float4(1.0,1.0,1.0,1.0);
                finalCol.r = tex2D(_MainTex,i.uv).r;
                finalCol.g = tex2D(_MainTex,i.uv - float2(_Offset,0)).g;
                finalCol.b = tex2D(_MainTex,i.uv + float2(_Offset,0)).b;

                return finalCol;
            }
            ENDCG
        }
    }
}

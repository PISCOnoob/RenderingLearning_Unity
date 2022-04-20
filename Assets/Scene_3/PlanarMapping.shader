Shader "MyShader/PlanarMapping"
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
                float4 worldPos = mul(unity_ObjectToWorld,v.pos);
                /*
                    actually we just project the texture on the top of the model(xz),or front(xy),side(zy)
                */
                o.uv = TRANSFORM_TEX(worldPos.zy, _MainTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                //float2 uv = normalize(i.uv);
                float4 finalCol = tex2D(_MainTex,i.uv);
                return finalCol;
            }
            ENDCG
        }
    }
}

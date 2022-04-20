Shader "MyShader/TimeFlow"
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
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {   
                float2 tilling = _MainTex_ST.xy;
                float2 offset = _MainTex_ST.zw;

                float time = _Time.y * 0.1;
                offset.x += time;
                float4 finalCol = tex2D(_MainTex,i.uv * tilling + offset);

                return finalCol;
            }
            ENDCG
        }
    }
}

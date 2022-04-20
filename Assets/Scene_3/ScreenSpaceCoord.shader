Shader "MyShader/ScreenSpaceCoord"
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
                float4 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;             
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;     //for tilling and offset

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                //o.uv = v.uv;
                o.uv = ComputeScreenPos(o.pos);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // what's the difference between uv0 and uv1?
                float2 SSuv_0 = i.uv.xy/i.uv.w;
                float aspectRatio = _ScreenParams.x/_ScreenParams.y;
                SSuv_0.x *= aspectRatio;

                float2 SSuv_1 = i.pos.xy/_ScreenParams.y;
                //return float4(i.pos.x,i.pos.y,0.0,1.0);
                // can this work?
                float2 suv = _ScreenParams.xy/_ScreenParams.w;
                float4 finalCol = tex2D(_MainTex,SSuv_0);
                return finalCol;
            }
            ENDCG
        }
    }
}

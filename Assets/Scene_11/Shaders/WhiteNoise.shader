Shader "MyShader/WhiteNoise"
{
    Properties
    {
       
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
            #include "../../UniversalResources/Shader/mylib_WhiteNoise.cginc"
            

            struct a2v
            {
                float4 vertex : POSITION;               
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 posWS : TEXCOORD0;             
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.posWS = mul(unity_ObjectToWorld,v.vertex).xyz;
                return o;
            }

           
            float4 frag (v2f i) : SV_Target
            {               
                float3 posWS = i.posWS;
                float4 finalCol = float4(1,1,1,1);

                float3 temp = Rand_3dTo3d(posWS);
                finalCol = float4(temp,1.0);
                return finalCol;
            }
            ENDCG
        }
    }
}

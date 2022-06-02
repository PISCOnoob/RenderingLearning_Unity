Shader "MyShader/Cells"
{
    Properties
    {
       _CellSize ("Cell Size",vector) = (1,1,1,0)
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
            
            float3 _CellSize;

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
                float3 value = floor(i.posWS / _CellSize);

                value = Rand_3dTo3d(value);
                
                float4 finalCol = float4(1,1,1,1);
             
                finalCol = float4(value,1.0);
                return finalCol;
            }
            ENDCG
        }
    }
}

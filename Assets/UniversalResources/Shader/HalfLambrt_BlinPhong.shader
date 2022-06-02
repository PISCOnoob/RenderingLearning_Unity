Shader "MyShader/VertexManipulation"
{
    Properties
    {
        _Shininess("Shininess",Range(0.0,60.0)) = 10.0

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

            float _Shininess;
            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;             
                float4 pos : SV_POSITION;
                float4 posWS : TESSFACTOR1;
                float3 normal : TEXCOORD2;
            };
           

            v2f vert (a2v v)
            {
                v2f o;
                //v.vertex.xyz *= 2;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.posWS = mul(unity_ObjectToWorld,v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
               float3 nDirWS = i.normal;
               float3 lDirWS = _WorldSpaceLightPos0.xyz;
               float3 vDirWS = normalize(_WorldSpaceCameraPos.xyz - i.posWS);
               float3 hDir = normalize(vDirWS + lDirWS);

               float3 halfLambert = dot(nDirWS,lDirWS) * 0.5 +0.5;
               float3 blinPhong = pow(max(0.0,dot(nDirWS,hDir)),_Shininess);



               float4 finalCol = float4(halfLambert + blinPhong,1.0);

                return finalCol;
            }
            ENDCG
        }
    }
}

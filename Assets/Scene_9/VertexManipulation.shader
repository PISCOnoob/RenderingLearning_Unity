Shader "MyShader/VertexManipulation"
{
    Properties
    {
        _Amplitude("Wave Amplitude",Range(0,1)) = 0.4
        _Frequency("Wave Frequency",Range(0,10)) = 2
        _AnimationSpeed("AnimationSpeed",Range(0,5)) = 1
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
            float _Amplitude;
            float _Frequency;
            float _AnimationSpeed;

            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float3 tangent : TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;             
                float4 pos : SV_POSITION;
                float4 posWS : TESSFACTOR1;
                float3 normal : TEXCOORD2;
                float3 tangent : TEXCOORD3;
                float3 bitangent : TEXCOORD4;
                float3 normalWS : TEXCOORD5;
            };
           

            v2f vert (a2v v)
            {
                v2f o;

                float4 modifiedPos = v.vertex;
                modifiedPos.y +=sin(v.vertex.x * _Frequency + _Time.y * _AnimationSpeed) * _Amplitude;

                float3 posPlusTangent = v.vertex + v.tangent * 0.01;
                posPlusTangent.y += sin(posPlusTangent.x * _Frequency + _Time.y * _AnimationSpeed) * _Amplitude;

                float3 bitangent = cross(v.normal,v.tangent);
                float3 posPlusBitangent = v.vertex + bitangent * 0.01;
                posPlusBitangent.y += sin(posPlusBitangent.x * _Frequency + _Time.y * _AnimationSpeed) * _Amplitude;

                float3 modifiedTangent = posPlusTangent - modifiedPos;
                float3 modifiedBitangent = posPlusBitangent - modifiedPos;

                float3 modifiedNormal = normalize(cross(modifiedTangent, modifiedBitangent));

                o.pos = UnityObjectToClipPos(modifiedPos);
                o.posWS = mul(unity_ObjectToWorld,modifiedPos);
                o.normalWS = UnityObjectToWorldNormal(modifiedNormal);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
               float3 nDirWS = i.normalWS;
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

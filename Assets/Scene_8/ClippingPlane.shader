Shader "MyShader/ClippingPlane
"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _InsideColor ("Inside Color",Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Off

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
                float3 normal : TEXCOORD1;

            };

            struct v2f
            {
                float2 uv : TEXCOORD0;             
                float4 pos : SV_POSITION;
                float3 posWS : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;     //for tilling and offset
            
            float4 _Plane;
            float4 _InsideColor;

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.posWS = mul(unity_ObjectToWorld,v.vertex).xyz;
                o.normalWS = UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 frag (v2f i,float facing : VFACE) : SV_Target
            {

                float4 var_tex = tex2D(_MainTex,i.uv);

                float distance = dot(i.posWS,_Plane.xyz);

                 distance += _Plane.w;

                clip(-distance);

                facing = facing * 0.5 + 0.5;

                float4 finalCol = lerp(_InsideColor,-distance * var_tex,facing);
                
                return finalCol;
            }
            ENDCG
        }
    }
}

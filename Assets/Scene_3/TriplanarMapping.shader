Shader "MyShader/TriplanarMapping"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Sharpness("Sharpness",Range(1,64)) = 1
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0;             
                float3 posWS : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;     //for tilling and offset
            float _Sharpness;

            v2f vert (a2v v)
            {
                v2f o;
                // calculate the position in clip space to render the object
                o.pos = UnityObjectToClipPos(v.pos);
                // calculate world position of vertex
                o.posWS = mul(unity_ObjectToWorld,v.pos).xyz;
                // calculate normal in world space
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.normal = normalize(worldNormal);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // calculate UV coordinates for three projection
                float2 uv_front = TRANSFORM_TEX(i.posWS.xy,_MainTex);
                float2 uv_side = TRANSFORM_TEX(i.posWS.zy,_MainTex);
                float2 uv_top = TRANSFORM_TEX(i.posWS.xz,_MainTex);

                // sample 3 times using different uv for different direction(front side top)
                float4 tex_front = tex2D(_MainTex,uv_front);
                float4 tex_side = tex2D(_MainTex,uv_side);
                float4 tex_top = tex2D(_MainTex,uv_top);
                // now we use normal of model as weight for different direction
                float3 weight = i.normal;
                // make sure value of weight is positive
                weight = abs(weight);
                // control the transition of boundaries smoother or sharper
                weight = pow(weight,_Sharpness);
                // make it so the sum of all components is 1, or the output will be brighter than we expected
                weight = weight/(weight.x + weight.y + weight.z);
                //return float4(weight,1);
                // multiply col with its weight
                tex_front *= weight.z;
                tex_side *= weight.x;
                tex_top *= weight.y;

                float4 finalCol = tex_front + tex_side + tex_top;
                return finalCol;
            }
            ENDCG
        }
    }
}

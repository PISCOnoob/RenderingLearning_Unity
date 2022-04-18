Shader "MyShader/RotateMatrix_2D"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Degree ("Degree",range(0,360)) = 0
        
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
            float _Degree;

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            #define PI 3.14159

            float4 frag (v2f i) : SV_Target
            {
               // origin uv
               float x = i.uv.x;
               float y = i.uv.y;

               // convert degree to radian
               float radian = _Degree / 360.0 * PI * 2;
               /*
               [cos d   -sin d    [x
                sin d    cos d]    y]
                */

                float a = cos(radian);
                float b = -sin(radian);
                float c = sin(radian);
                float d = cos(radian);

                float nx = a * x + b * y;
                float ny = c * x + d * y;
                
                float4 finalCol = tex2D(_MainTex,float2(nx,ny));
                return finalCol;
            }
            ENDCG
        }
    }
}

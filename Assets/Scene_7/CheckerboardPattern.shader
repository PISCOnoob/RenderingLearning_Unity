Shader "MyShader/CheckerboardPattern"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Scale ("Pattern Size",Range(0,10)) = 1 
        _EvenColor("Color 1",Color) = (1.0,1.0,1.0,1.0)
        _OddColor("Color 2",Color) = (0.0,0.0,0.0,1.0)
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
            
            float _Scale;
            float4 _EvenColor;
            float4 _OddColor;

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
               float3 adjustedPosWS = floor(i.posWS / _Scale);
               float chessboard = adjustedPosWS.x + adjustedPosWS.y + adjustedPosWS.z;
               chessboard = abs(chessboard % 2);
               //chessboard = frac(chessboard * 0.5);
               //chessboard *= 2;
               float4 finalCol = lerp(_EvenColor,_OddColor,chessboard);
               return finalCol;
            }
            ENDCG
        }
    }
}

Shader "MyShader/HullOutlines"
{
    Properties
    {
        // for first pass
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint Color",color) = (0,0,0,1)

        // for second pass
        _OutlineColor ("Outline Color",Color) = (0,0,0,1)
        _OutlineThickness ("Outline Thickness",Range(0,1)) = 0.05
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
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;             
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;    //for tilling and offset
            float4 _Color;

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {

                float4 finalCol = tex2D(_MainTex,i.uv);
                finalCol *=_Color;

                return finalCol;
            }
            ENDCG
        }

       //the second pass where we render the outlines
        pass
        {
            Cull Front

            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            float4 _OutlineColor;
            float _OutlineThickness;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL; 
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            v2f vert(a2v v)
            {
                v2f o;
                float3 normal = normalize(v.normal);
                float3 outlineOffset = normal * _OutlineThickness;
                float3 position = v.vertex + outlineOffset;
                o.pos = UnityObjectToClipPos(position);
                return o;
            }

            float4 frag(v2f i) : SV_TARGET
            {
                return _OutlineColor;
            }
            ENDCG
        }
    }
    FallBack"Standard"
}

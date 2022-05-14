Shader "MyShader/PolygonClipping"
{
    Properties
    {
        _Color("Color",Color) = (0,0,0,1)
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

            uniform float2 _PointsArray[1000];
            uniform uint _PointCount;
            
            float4 _Color;

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

            float IsLeftOfLine(float2 pos,float2 linePoint0,float2 linePoint1)
            {
                float2 lineDirection = linePoint1 - linePoint0;
                float2 lineNormal = float2(-lineDirection.y,lineDirection.x);
                float2 toPos = pos - linePoint0;

                float side = dot(toPos,lineNormal);
                side = step(0,side);
                return side;
            }
            float4 frag (v2f i) : SV_Target
            {
                float outsideTriangle = 0;

                [loop]
                for(uint index = 0;index<_PointCount;index++)
                {
                    outsideTriangle += IsLeftOfLine(i.posWS,_PointsArray[index],_PointsArray[(index+1)%_PointCount]);
                }
                
                clip(-outsideTriangle);

                return _Color;
            }
            ENDCG
        }
    }
}

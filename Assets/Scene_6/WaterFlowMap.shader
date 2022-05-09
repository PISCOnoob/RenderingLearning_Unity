Shader "MyShader/WaterFlowMap"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FlowMap ("FlowMap",2D) = "white"{}
        _FlowSpeed ("FlowSpeed",Range(0,10)) = 1
        _Intensity ("Intensity",Range(0,1)) = 0.1

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

            sampler2D _MainTex;
            float4 _MainTex_ST;     //for tilling and offset
            sampler2D _FlowMap;
            float _FlowSpeed;
            float _Intensity;

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

            

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // ���ȴ�flowmap�л�ȡ���򣬲������ӳ��
                float4 flowDir=tex2D(_FlowMap,i.uv) * 2.0 - 1.0;
                flowDir *= _Intensity;

                // ƽ����ͼ�õ�uv
                float2 tillingUV = i.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                // ����������ͬ�����ǲ�����λ�ĺ�����0-1����һ������
                float phase0 = frac(_Time.x * _FlowSpeed ) ;
                float phase1 = frac(_Time.x * _FlowSpeed + 0.5); 
                // ��������
                float4 layer0 = tex2D(_MainTex, tillingUV + flowDir.xy * phase0 );
                float4 layer1 = tex2D(_MainTex, tillingUV + flowDir.xy * phase1 );

                
                float weight = abs(2.0 * phase0 - 1);

                float4 finalCol = lerp(layer0,layer1,weight);

                return finalCol;
            }
            ENDCG
        }
    }
}

Shader "MyShader/SplattingTexture"
{
    Properties
    {
        _tex0("tex0", 2D) = "white"{}
		_tex1("tex1", 2D) = "white"{}
		_tex2("tex2", 2D) = "white"{}
		_tex3("tex3", 2D) = "white"{}
		_tex4("tex4", 2D) = "white"{}
		_texMask("texMask", 2D) = "white"{}

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

            sampler2D texMask;

			sampler2D _tex0;
			sampler2D _tex1;
			sampler2D _tex2;
			sampler2D _tex3;
			sampler2D _tex4;
            sampler2D _texMask;

			float4    _tex0_ST;
			float4    _tex1_ST;
			float4    _tex2_ST;
			float4    _tex3_ST;
			float4    _tex4_ST;

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

            float4 DetailedTexture(sampler2D tex,float4 st,float2 uv)
            {
                uv = uv * st.xy + st.zw;
                float4 o = tex2D(tex,uv);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {              
                float2 uv = i.uv;
                float4 t0 =DetailedTexture(_tex0,_tex0_ST,uv);
                float4 t1 =DetailedTexture(_tex1,_tex1_ST,uv); 
                float4 t2 =DetailedTexture(_tex2,_tex2_ST,uv);
                float4 t3 =DetailedTexture(_tex3,_tex3_ST,uv);
                float4 t4 =DetailedTexture(_tex4,_tex4_ST,uv);

                float4 mask = tex2D(_texMask,uv);
                float parity = 1 - mask.r - mask.g - mask.b - mask.a;

                float4 finalCol = t0 * mask.r 
                                + t1 * mask.g
                                + t2 * mask.b
                                + t3 * mask.a
                                + t4 * parity;
                
                return finalCol;
            }
            ENDCG
        }
    }
}

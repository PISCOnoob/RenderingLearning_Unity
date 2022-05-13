shader "myshader/dota2"
{
    properties
    {   
        [Header(Texture)]
        _MainTex ("rgb:color a:transparency", 2d) = "white" {}
        _MaskTex ("r:specIntensity g:rimIntensity b:specInt a:specPower",2d) = "black"{}
        _NormalTex ("rgb:noramlMap",2d) = "bump"{}
        _MetalnessMask ("metalnessMask",2d) = "black"{}
        _EmissionMask ("emissionMask",2d) = "black"{}
        _DiffWarpTex ("colorWarpTex",2d) = "white"{}
        _FresnelWarpTex ("fresnelWarpTex",2d) = "gray"{}
        _Cubemap ("cubemap",cube) = "_skybox"{}
        
        [Header(DirDiff)]
        _LightColor ("lightColor",color)  = (1.0,1.0,1.0,1.0)
        [header(DirSpec)]
        _SpecPow ("specPower",Range(0.0,99.0)) = 5
        _SpecInt ("specIntensity",Range(0.0,10.0)) = 5
        [Header(EnvDiff)]
        _EnvColor ("envColor",color) = (1.0,1.0,1.0,1.0)
        [Header(EnvSpec)]
        _EnvspecInt ("envspecIntensity",Range(0.0,30.0)) = 0.5
        [Header(rimlight)]
        [hdr]_RimCol ("rimLightColor",color) = (1.0,1.0,1.0,1.0)
        _RimInt ("rimLightIntensity",Range(0.0,5.0)) = 1.0
        [Header(Emission)]
        _emitInt ("emissionIntensity",Range(0.0,10.0)) = 1.0
        [HideInInspector]
        _Cutoff ("alpha cutoff",Range(0,1)) = 0.5
        [HideInInspector]
        _color ("main color",color) = (1.0,1.0,1.0,1.0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        //lod 100

        Pass
        {
            Name "FORWARD"
            Tags {"LightMode"="ForwardBase"}
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"

            #pragma multi_compile_fwbase_fullshadows
            #pragma target 3.0

            // variable declaration
            uniform sampler2D _MainTex;
            uniform sampler2D _MaskTex;
            uniform sampler2D _NormalTex;
            uniform sampler2D _MetalnessMask;
            uniform sampler2D _EmissionMask;
            uniform sampler2D _DiffWarpTex;
            uniform sampler2D _FresnelWarpTex;
            uniform samplerCUBE _Cubemap;

            uniform float3 _LightColor;

            uniform float _SpecPow;
            uniform float _SpecInt;

            uniform float3 _EnvColor;

            uniform float _EnvspecInt;

            uniform float3 _RimCol;
            uniform float _RimInt;

            uniform float _emitInt;

            uniform float _Cutoff;

            struct a2v
            {
                float4 vertex : POSITION;      // vertex
                float2 uv : TEXCOORD0;      // uv
                float4 noraml : NORMAL;     // normal
                float4 tangent : TANGENT;   // tangent
            };

            struct v2f
            {
                float4 pos : SV_POSITION;   // vertex position in screen space
                float2 uv : TEXCOORD0;      // uv
                float4 posWS : TEXCOORD1;   // vertex position in world space
                float3 tDirWS : TEXCOORD2;  // tangent direction in world space
                float3 bDirWS : TEXCOORD3;  // bitangent direction in world space
                float3 nDirWS : TEXCOORD4;  // normal direction in world space
                LIGHTING_COORDS(5,6)
                //LIGHTING_COORDS(5,6)
            };

            

            v2f vert (a2v v)
            {
                v2f o =(v2f)0;     // initialize v2f struct
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.posWS = mul(unity_ObjectToWorld,v.vertex);
                o.nDirWS = UnityObjectToWorldNormal(v.noraml);      // normal from model
                o.tDirWS = normalize(mul(unity_ObjectToWorld,float4(v.tangent.xyz,0.0)).xyz);
                o.bDirWS = normalize(cross(o.nDirWS,o.tDirWS) * v.tangent.w);
                //TRANSFER_VERTEX_TO_FRAGMENT(o)        // related to projection
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }

            float4 frag (v2f i) : sv_target
            {
               // preparation for vector
               float3 nDirTS = UnpackNormal(tex2D(_NormalTex,i.uv));
               float3x3 TBN = float3x3(i.tDirWS,i.bDirWS,i.nDirWS);     // unity matrix are column-major
               float3 nDirWS = normalize(mul(nDirTS,TBN));
               
               float3 vDirWS = normalize(_WorldSpaceCameraPos.xyz - i.posWS);
               float3 vrDirWS = reflect(-vDirWS,nDirWS);
               float3 lDirWS = _WorldSpaceLightPos0.xyz;
               float3 lrDirWS = reflect(-lDirWS,nDirWS);
               // preparation for later lighting calculating
               float ndotl = dot(nDirWS,lDirWS);
               float ndotv = dot(nDirWS,vDirWS);
               float vdotr = dot(vDirWS,lrDirWS);
               // sample texture
               float4 var_MainTex = tex2D(_MainTex,i.uv);
               float4 var_MaskTex = tex2D(_MaskTex,i.uv);
               float4 var_MetalnessMask = tex2D(_MetalnessMask,i.uv).r;
               float4 var_EmissionTex = tex2D(_EmissionMask,i.uv).r;
               float4 var_fresnelWarp = tex2D(_FresnelWarpTex,ndotv);       
               // lerp specIntensity in cubemap, meaning that the smoother the place the clearer the reflection
               float3 var_Cubemap = texCUBElod(_Cubemap,float4(vrDirWS,lerp(8.0,0.0,var_MaskTex.a))).rgb;
               // get channel info
               float3 baseCol = var_MainTex.rgb;
               float opacity = var_MainTex.a;
               float specInt = var_MaskTex.r;
               float rimint = var_MaskTex.g;
               float specTint = var_MaskTex.b;
               float specPow = var_MaskTex.a;
               float metallic = var_MetalnessMask;      // note that we only use r channel
               float emitInt = var_EmissionTex;     // note that we only use r channel
               float3 envCube = var_Cubemap;
               float shadow = LIGHT_ATTENUATION(i);
               //return float4(shadow,shadow,shadow,1.0);
               // light model

               // fresnel
               float3 fresnel = lerp(var_fresnelWarp,0.0,metallic);
               float fresnelCol = fresnel.r;
               float fresnelRim = fresnel.g;
               float fresnelSpec = fresnel.b;
               // specular reflection
               float3 specCol = lerp(baseCol,float3(0.3,0.3,0.3),specTint);
               float phong = pow(max(0.0,vdotr),specPow * _SpecPow);
               float spec = phong * max(0.0,ndotl);
               spec = max(spec,fresnelSpec);
               spec = spec * _SpecInt;
               float3 dirSpec = specCol * spec * _LightColor;
               // diffuse
               float3 diffCol = lerp(baseCol,float3(0.0,0.0,0.0),metallic);
               float halfLambert = ndotl * 0.5 + 0.5;
               float3 var_DiffWarpTex = tex2D(_DiffWarpTex,float2(halfLambert,0.2));
               float3 dirDiff = diffCol * var_DiffWarpTex * _LightColor;
               
               
               // env diffuse
               float3 envDiff = diffCol * _EnvColor;
               // env specular
               float reflectint = max(fresnelSpec,metallic) * specInt;
               float3 envSpec = specCol * reflectint * envCube * _EnvspecInt;
               // rim light
               float3 rimlight = _RimCol * fresnelRim * rimint * max(0.0,nDirWS.g);
               // emission
               float3 emission = diffCol * emitInt * _emitInt;
               //
               float3 finalCol = (dirDiff + dirSpec) * shadow + envDiff + envSpec + rimlight + emission;
               
               clip(opacity - _Cutoff);
               return float4(finalCol,1.0);
            }
            ENDCG
        }
    }
    FallBack "Legacy Shaders/Transparent/Cutout/VertexLit"
}

Shader "Unlit/ToonWaterShader"
{
    Properties
    {
        _ShallowColor("Depth Color Shallow", Color) = (0.325, 0.807, 0.971, 0.725)
        _DeepColor("Depth Color Deep", Color) = (0.086, 0.407, 1, 0.749)
        _DepthMaxDistance("Depth Maximum Distance", float) = 1.0
        _NoiseTex("Noise", 2D) = "white"{}
        _SurfaceNoiseCutoff("Surface Noise Cutoff", Range(0, 1)) = 0.777
        _FoamDistance("Foam Distance", float) = 0.5
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

            float4 _ShallowColor;
            float4 _DeepColor;
            float _DepthMaxDistance;
            sampler2D _CameraDepthTexture;
            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;
            float _SurfaceNoiseCutoff;
            float _FoamDistance;

            struct vertexInput
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };

            struct vertexOutput
            {
                float4 vertex : SV_POSITION;
                float4 screenPosition : TEXCOORD2;
                float2 noiseUV : TEXCOORD0;
            };

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPosition = ComputeScreenPos(o.vertex);
                //o.noiseUV = TRANSFORM_TEX(v.uv, _NoiseTex_ST);
                o.noiseUV = v.uv.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
                return o;
            }

            fixed4 frag (vertexOutput i) : SV_Target
            {
                float existingDepth = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPosition)).r;
                float existingDepthLinear = LinearEyeDepth(existingDepth);
                float depthDifference = existingDepthLinear - i.screenPosition.w;
                
                float waterDepthDifference = saturate(depthDifference / _DepthMaxDistance);
                float4 waterColor = lerp(_ShallowColor, _DeepColor, waterDepthDifference);
                
                float surfaceNoiseSample = tex2D(_NoiseTex, i.noiseUV).r;
                float foamDepthDifference = saturate(depthDifference / _FoamDistance);
                float surfaceNoiseCutoff = foamDepthDifference * _SurfaceNoiseCutoff;
                float surfaceNoise = surfaceNoiseSample > surfaceNoiseCutoff ? 1 : 0;
                
                return waterColor + surfaceNoise;
            }
            ENDCG
        }
    }
}
Shader "Unlit/GradientShader"
{
    Properties
    {
        _MainColor("Main Color",Color)=(1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _SecondaryColor("Secondary Color",Color)=(1,1,1,1)
        _SecondaryTex("Secondary Texture", 2D) = "white"{}
        _Width("Width", float) = 0.1
        _Amount("Amount", int) = 3
    }
    SubShader
    {
        Tags { 
           "RenderType"="Opaque"
           "Queue" = "Transparent"
           "RenderType" = "Transparent"
           "IgnoreProjector" = "True"
        }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            fixed4 _MainColor;
            fixed4 _SecondaryColor;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform sampler2D _SecondaryTex;
            uniform float4 _SecondaryTex_ST;
            float _Width;
            int _Amount;

            float drawLine(float2 uv)
            {
                float gap = 1.0/_Amount;

                if (uv.x % gap > 0 && uv.x % gap < _Width)
                {
                    return 1;
                }
                return 0;
            }

            struct vertexInput
            {
                float4 vertex : POSITION;
                float2 texcoord: TEXCOORD0;
            };

            struct vertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 texcoord: TEXCOORD0;
            };

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                return o;
            }

            half4 frag (vertexOutput i) : SV_Target
            {
                float4 mainColor = tex2D(_MainTex, i.texcoord) * _MainColor;
                mainColor *= 1 - i.texcoord.x;
                float4 secondaryColor = tex2D(_SecondaryTex, i.texcoord) * _SecondaryColor;
                secondaryColor *= i.texcoord.x;

                return mainColor + secondaryColor;
            }
            ENDCG
        }
    }
}

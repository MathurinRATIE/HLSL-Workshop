Shader "Unlit/AlternatedLineShader"
{
    Properties
    {
        _Color1("Color1",Color)=(1,1,1,1)
        _Color2("Color2",Color)=(1,1,1,1)
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
            
            fixed4 _Color1;
            fixed4 _Color2;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
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
                fixed4 color1 = _Color1;
                fixed4 color2 = _Color2;

                color1.a = drawLine(i.texcoord);
                color2.a = 1 - drawLine(i.texcoord);

                if (color1.a > 0)
                {
                    return color1;
                }
                return color2;
            }
            ENDCG
        }
    }
}


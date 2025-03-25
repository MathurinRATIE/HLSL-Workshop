Shader "Unlit/MonochromeShader"
{
    Properties
    {
        _Color("Color",Color)=(1,0,0,1)
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

            fixed4 _Color;

            struct vertexInput
            {
                float4 vertex : POSITION;
            };

            struct vertexOutput
            {
                float4 vertex : SV_POSITION;
            };

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (vertexOutput i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}

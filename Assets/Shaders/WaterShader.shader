Shader "Unlit/WaterShader"
{
    Properties
    {
        _MainColor("Color",Color)=(1,1,1,1)
        _SecondaryColor("Color",Color)=(1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
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
            
            fixed4 frag (vertexOutput i) : SV_Target
            {
                fixed4 mainColor = (1 - tex2D(_MainTex, i.texcoord).x) * _MainColor;
                fixed4 secondaryColor = tex2D(_MainTex, i.texcoord).x * _SecondaryColor;
                return mainColor + secondaryColor;
            }
            ENDCG
        }
    }
}

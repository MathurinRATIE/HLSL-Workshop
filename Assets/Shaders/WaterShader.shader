Shader "Unlit/WaterShader"
{
    Properties
    {
        _MainColor("Color",Color)=(1,1,1,1)
        _SecondaryColor("Color",Color)=(1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _Displacement("Displacement", float)= 0
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
                float4 normal: NORMAL;
                float2 texcoord: TEXCOORD0;
            };

            struct vertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 texcoord: TEXCOORD0;
                float displacement: Displacement;
                float amplitude: Amplitude;
            };

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;
                o.displacement = tex2Dlod(_MainTex, float4(v.texcoord * _MainTex_ST + float2(sin(_Time.x) / 3, sin(_Time.x)), v.texcoord * _MainTex_ST.zw));
                o.vertex = UnityObjectToClipPos(v.vertex + (v.normal * o.displacement * 0.5));
                o.amplitude = sin(_Time.x * 50 + v.texcoord.x * 10 + v.texcoord.y * 3) / 5;
                o.vertex += float4(0,o.amplitude,0,0);
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                
                return o;
            }
            
            fixed4 frag (vertexOutput i) : SV_Target
            {
                fixed4 mainColor = (1 - (i.displacement - i.amplitude / 2 - 0.2)) * _MainColor;
                fixed4 secondaryColor = (i.displacement - i.amplitude / 2 - 0.2) * _SecondaryColor;
                return mainColor + secondaryColor;
            }
            ENDCG
        }
    }
}

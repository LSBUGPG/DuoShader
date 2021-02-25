Shader "ScreenEffect/DuoShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DevelopedColour ("Developed Colour", Color) = (0, 0, 0)
        _UndevelopedColour ("Undeveloped Colour", Color) = (1, 1, 1)
        _InkColour ("Ink Colour", Color) = (0, 0, 0)
        _PaperColour ("Paper Colour", Color) = (1, 1, 1)
        _UndevelopedLevel ("Undeveloped Level", Range(0, 1)) = 0.05
        _Frequency ("Frequency", Range(3, 20)) = 7
        _Thickness ("Thickness", Range(0, 1)) = 0.15
        _Fringe ("Fringe", Range(0, 1)) = 0.1
        _Black ("Black", Range(0, 1)) = 0.2
        _Dark ("Dark Tone", Range(0, 1)) = 0.4
        _Light ("Light Tone", Range(0, 1)) = 0.8
        _PrintBlackLevel ("Print Black Level", Range(0, 1)) = 0.7
        _Noise ("Noise", Range(0, 1)) = 0.01
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float3 _DevelopedColour;
            float3 _UndevelopedColour;
            float3 _InkColour;
            float3 _PaperColour;
            float _UndevelopedLevel;
            float _Frequency;
            float _Thickness;
            float _Fringe;
            float _Black;
            float _Dark;
            float _Light;
            float _PrintBlackLevel;
            float _Noise;

            float slice(float low, float high, float value)
            {
                return 1.0 - (1.0 - step(low, value)) - step(high, value);
            }

            float noise(float2 uv)
            {
                // variation on the noise function used by Unity PostProcessing
                // grain effect
                return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
            }

            float shade(float l, float2 uv)
            {
                float f1 = _Frequency;
                float width = _ScreenParams.x / f1;
                float height = _ScreenParams.y / f1;
                float l1 = uv.x * width + uv.y * height;
                float f2 = _Frequency;
                width = _ScreenParams.x / f2;
                height = _ScreenParams.y / f2;
                float l2 = uv.x * width + (1.0 - uv.y) * height;
                float d1 = (abs(0.5 - frac(l1)) * 2.0);
                float d2 = (abs(0.5 - frac(l2)) * 2.0);

                float dark = (1.0 - smoothstep(_Black, _Dark, l)) * slice(_Black, _Dark, l);
                float light = (1.0 - smoothstep(_Dark, _Light, l)) * slice(_Black, _Light, l);

                float s1 = smoothstep(1.0 - _Thickness - _Fringe, 1.0 - _Thickness, d1);
                float s2 = smoothstep(1.0 - _Thickness - _Fringe, 1.0 - _Thickness, d2);
                
                float hatch = saturate(s1 * (light + _UndevelopedLevel) + s2 * (dark + _UndevelopedLevel));
                return hatch;
            }

            float luma(float3 col)
            {
                float3 coefs = float3(0.2126, 0.7152, 0.0722);
                return dot(coefs, col);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv.xy;
                fixed4 col = tex2D(_MainTex, uv);
                float3 rgb = col.rgb;
                float l = luma(rgb) + noise(uv) * _Noise;
                float3 s = shade(l, uv);
                rgb = lerp(float3(1, 1, 1), lerp(_UndevelopedColour, _DevelopedColour, s), step(_UndevelopedLevel, s));
                float black = 1.0 - step(_Black, l);
                rgb *= (1.0 - black);
                col.rgb = lerp(_InkColour, _PaperColour, step(_PrintBlackLevel, luma(rgb) + noise(uv) * _Noise));
                return col;
            }
            ENDCG
        }
    }
}

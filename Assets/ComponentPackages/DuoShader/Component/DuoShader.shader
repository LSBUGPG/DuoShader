Shader "ScreenEffect/DuoShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Frequency ("Frequency", Range(3, 20)) = 7
        _Level ("Level", Range(0, 1)) = 0.15
        _Edge ("Edge", Range(0, 1)) = 0.1
        _Black ("Black", Range(0, 1)) = 0.2
        _Low ("Low", Range(0, 1)) = 0.4
        _Mid("Mid", Range(0, 1)) = 0.6
        _High ("High", Range(0, 1)) = 0.8
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
            float _Frequency;
            float _Level;
            float _Edge;
            float _Black;
            float _Low;
            float _Mid;
            float _High;

            float slice(float low, float high, float value)
            {
                return 1.0 - (1.0 - step(low, value)) - step(high, value);
            }

            float shade(float l, float2 uv)
            {
                float f = _Frequency;
                float width = _ScreenParams.x / f;
                float height = _ScreenParams.y / f;
                float l1 = uv.x * width + uv.y * height;
                float l2 = uv.x * width + (1.0 - uv.y) * height;
                float d1 = (abs(0.5 - frac(l1)) * 2.0);
                float d2 = (abs(0.5 - frac(l2)) * 2.0);

                float white = step(_High, l);
                float black = 1.0 - step(_Black, l);
                float low = ((1.0 - smoothstep(_Black, _Low, l)) * 0.5 + 0.5) * slice(_Black, _Low, l);
                float mid = ((1.0 - smoothstep(_Low, _Mid, l)) * 0.5 + 0.5) * slice(_Low, _Mid, l);
                float high = ((1.0 - smoothstep(_Mid, _High, l)) * 0.5) * slice(_Mid, _High, l);

                float s1 = smoothstep(1.0 - _Level - _Edge, 1.0 - _Level, d2);
                float s2 = smoothstep(1.0 - _Level - _Edge, 1.0 - _Level, d1);
                
                float3 tones = float3(high, mid, low);
                float hatch = 1.0 - dot(float3(s1, s2, (s1 + s2)), tones);

                return saturate(white + hatch * (1.0 - black));
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
                float s = shade(luma(rgb), uv);
                col.rgb = s;
                return col;
            }
            ENDCG
        }
    }
}

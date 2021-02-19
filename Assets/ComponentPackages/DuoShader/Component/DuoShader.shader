Shader "ScreenEffect/DuoShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Frequency ("Frequency", Range(3, 10)) = 7
        _Level ("Level", Range(0, 1)) = 0.15
        _Edge ("Edge", Range(0, 1)) = 0.1
        _Black ("Black", Range(0, 1)) = 0.2
        _Low ("Low", Range(0, 1)) = 0.4
        _High ("High", Range(0, 1)) = 0.6
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
            float _High;

            float shade(float l, float2 uv)
            {
                float f = _Frequency;
                float l1 = uv.x * _ScreenParams.x + uv.y * _ScreenParams.y;
                float l2 = uv.x * _ScreenParams.x + (1.0 - uv.y) * _ScreenParams.y;
                float d1 = 1.0 - abs(0.5 - fmod(l1, f) / f);
                float d2 = 1.0 - abs(0.5 - fmod(l2, f) / f);

                float c = step(_High, l);
                float c1 = 1.0 - smoothstep(_Low, _High, l);
                float c2 = 1.0 - smoothstep(_Black, _Low, l);
                float c3 = step(_Black, l);

                float s1 = smoothstep(1.0 - (_Level + _Edge), 1.0 - _Level, d1) * c1;
                float s2 = smoothstep(1.0 - (_Level + _Edge), 1.0 - _Level, d2) * c2;

                float hatch = min(1.0 - s1, 1.0 - s2);

                return saturate(c + hatch * c3);
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

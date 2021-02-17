Shader "ScreenEffect/DuoShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Frequency ("Frequency", Range(3, 10)) = 5
        _Level ("Level", Range(0,1)) = 0.1
        _Width ("Width", Range(0,5)) = 5
        _Tones ("Tones", Vector) = (0.0, 0.25, 0.5, 0.75)
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
            float _Width;
            float4 _Tones;

            float shade(float l, float2 uv)
            {
                float f = _Frequency;
                float l1 = uv.x * _ScreenParams.x + uv.y * _ScreenParams.y;
                float l2 = uv.x * _ScreenParams.x + (1.0 - uv.y) * _ScreenParams.y;
                float d1 = 1.0 - abs(0.5 - fmod(l1, f) / f);
                float d2 = 1.0 - abs(0.5 - fmod(l2, f) / f);

                float c = step(_Tones.z, l);
                float c1 = 1.0 - smoothstep(_Tones.y, _Tones.z, l);
                float c2 = 1.0 - smoothstep(_Tones.x, _Tones.y, l);
                float c3 = step(_Tones.x, l);

                float s1 = smoothstep(1.0 - _Level, 1.0, d1) * c1;
                float s2 = smoothstep(1.0 - _Level, 1.0, d2) * c2;

                return saturate(c + (1.0 - (s1 + s2)) * c3);
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
                float du = (_ScreenParams.z - 1.0f) * _Width;
                float dv = (_ScreenParams.w - 1.0f) * _Width;
                float dcol = 0;
                dcol = max(dcol, length(rgb - tex2D(_MainTex, uv + float2(du, 0.0)).rgb));
                dcol = max(dcol, length(rgb - tex2D(_MainTex, uv + float2(-du, 0.0)).rgb));
                dcol = max(dcol, length(rgb - tex2D(_MainTex, uv + float2(0.0, dv)).rgb));
                dcol = max(dcol, length(rgb - tex2D(_MainTex, uv + float2(0.0, -dv)).rgb));

                float s = shade(luma(rgb), uv);
                float l = smoothstep(1.0 - 2.0 * _Tones.w, 1.0 - _Tones.w, 1.0 - dcol);
                col.rgb = s * l;
                return col;
            }
            ENDCG
        }
    }
}

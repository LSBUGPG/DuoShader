Shader "Hidden/Custom/DuoShader"
{
    HLSLINCLUDE
    #include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
    TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

    float3 _DevelopedColour;
    float3 _UndevelopedColour;
    float _UndevelopedLevel;
    float _Frequency;
    float _Thickness;
    float _Black;
    float _Dark;
    float _Light;
    float _NoiseLevel;

    float slice(float low, float high, float value)
    {
        return 1.0 - (1.0 - step(low, value)) - step(high, value);
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

        float s1 = step(1.0 - _Thickness, d1);
        float s2 = step(1.0 - _Thickness, d2);
        
        float hatch = saturate(s1 * (light + _UndevelopedLevel) + s2 * (dark + _UndevelopedLevel));
        return hatch;
    }

    float noise(float2 uv)
    {
        // magic values copied from Unity Post Processing
        float3 p = float3(12.9898f, 78.233f, 43758.5453f);
        return frac(sin(dot(uv, p.xy)) * p.z);
    }

    float luma(float3 col)
    {
        float3 coefs = float3(0.2126, 0.7152, 0.0722);
        return dot(coefs, col);
    }

    float4 frag (VaryingsDefault i) : SV_Target
    {
        float2 uv = i.texcoord;
        float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);
        float3 rgb = col.rgb;
        float l = luma(rgb);
        float3 s = shade(l + noise(uv) * _NoiseLevel, uv);
        rgb = lerp(float3(1, 1, 1), lerp(_UndevelopedColour, _DevelopedColour, s), step(_UndevelopedLevel, s));
        float black = 1.0 - step(_Black, l);
        rgb *= (1.0 - black);
        col.rgb = rgb;
        col.a = l;
        return col;
    }

    ENDHLSL
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            HLSLPROGRAM
            #pragma vertex VertDefault
            #pragma fragment frag
            ENDHLSL
        }
    }
}

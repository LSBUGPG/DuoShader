Shader "Hidden/Custom/Outline"
{
    HLSLINCLUDE
    #include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
    TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

    float _Detect;
    float _Thickness;

    float maxchannel(float3 c)
    {
        return max(max(c.r, c.g), c.b);
    }

    float4 frag (VaryingsDefault v) : SV_Target
    {
        float du = _ScreenParams.z - 1.0;
        float dv = _ScreenParams.w - 1.0;
        float2 uv[9] = {
            float2(-du, -dv),
            float2(0.0, -dv),
            float2( du, -dv),
            float2(-du, 0.0),
            float2(0.0, 0.0),
            float2( du, 0.0),
            float2(-du,  dv),
            float2(0.0,  dv),
            float2( du,  dv)
        };

        float3 p[9];
        for (int i = 0; i < 9; ++i)
        {
            p[i] = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, v.texcoord + uv[i] * _Thickness).rgb;
        }
        float3 sx = p[2] + (2.0 * p[5]) + p[8] - (p[0] + (2.0 * p[3]) + p[6]);
        float3 sy = p[0] + (2.0 * p[1]) + p[2] - (p[6] + (2.0 * p[7]) + p[8]);
        float l = step(_Detect, 1.0 - maxchannel(sqrt(sx * sx + sy * sy)));

        return float4(p[4] * l, 1.0);
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

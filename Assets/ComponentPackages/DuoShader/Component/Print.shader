Shader "Hidden/Custom/Print"
{
    HLSLINCLUDE
    #include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
    TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

    float3 _InkColour;
    float3 _PaperColour;
    float3 _InputColourCoefs;
    float3 _OutputColourCoefs;
    float _PrintBlackLevel;
    float _NoiseLevel;

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
        float l = luma(rgb) + noise(uv) * _NoiseLevel;
        col.rgb = lerp(_InkColour, _PaperColour, step(_PrintBlackLevel, l));
        col.a = luma(col.rgb);
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

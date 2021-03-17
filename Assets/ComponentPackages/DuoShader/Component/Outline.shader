Shader "Hidden/Custom/Outline"
{
    HLSLINCLUDE
    #include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
    TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
    TEXTURE2D_SAMPLER2D(_ColourNormalsTex, sampler_ColourNormalsTex);
    TEXTURE2D_SAMPLER2D(_CameraDepthNormalsTexture, sampler_CameraDepthNormalsTexture);

    float _Detect;
    float _Thickness;


    ENDHLSL
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass // 0
        {
            Name "Colour Normals Alpha"

            HLSLPROGRAM
            #pragma vertex VertDefault
            #pragma fragment frag

            float luma(float3 col)
            {
                float3 coefs = float3(0.2126, 0.7152, 0.0722);
                return dot(coefs, col);
            }

            float4 frag (VaryingsDefault v) : SV_Target
            {
                float3 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, v.texcoord).rgb;
                float4 dn = SAMPLE_TEXTURE2D(_CameraDepthNormalsTexture, sampler_CameraDepthNormalsTexture, v.texcoord);
                float3 n = DecodeViewNormalStereo(dn);
                return float4(lerp(n, col, 0.5), 1.0);
            }

            ENDHLSL
        }



        Pass // 1
        {
            Name "Outline Detect"

            HLSLPROGRAM
            #pragma vertex VertDefault
            #pragma fragment frag

            float maxchannel(float4 c)
            {
                return max(max(c.r, c.g), max(c.b, c.a));
            }

            float4 frag (VaryingsDefault v) : SV_Target
            {
                float4 col = SAMPLE_TEXTURE2D(
                    _MainTex,
                    sampler_MainTex,
                    v.texcoord);

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

                float4 p[9];
                for (int i = 0; i < 9; ++i)
                {
                    p[i] = SAMPLE_TEXTURE2D(
                        _ColourNormalsTex,
                        sampler_ColourNormalsTex,
                        v.texcoord + uv[i] * _Thickness);
                }
                float4 sx = p[2] + (2.0 * p[5]) + p[8] - (p[0] + (2.0 * p[3]) + p[6]);
                float4 sy = p[0] + (2.0 * p[1]) + p[2] - (p[6] + (2.0 * p[7]) + p[8]);
                float l = step(_Detect, 1.0 - maxchannel(sqrt(sx * sx + sy * sy)));

                return float4(col.rgb * l, l);
            }

            ENDHLSL
        }
    }
}

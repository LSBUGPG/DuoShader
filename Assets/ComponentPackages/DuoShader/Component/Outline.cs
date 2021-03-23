using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[System.Serializable]
[PostProcess(typeof(OutlineRenderer), PostProcessEvent.AfterStack, "Custom/Outline")]
public class Outline : PostProcessEffectSettings
{
    public FloatParameter thickness = new FloatParameter
    {
        value = 1.5f
    };
    [Range(0.0f, 1.0f)]
    public FloatParameter detect = new FloatParameter
    {
        value = 0.25f
    };
    public BoolParameter debug = new BoolParameter
    {
        value = false
    };
}

public class OutlineRenderer : PostProcessEffectRenderer<Outline>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(
            Shader.Find("Hidden/Custom/Outline"));

        if (settings.debug)
        {
            context.command.BlitFullscreenTriangle(
                context.source,
                context.destination,
                sheet,
                0);
        }
        else
        {
            RenderTexture renderTexture = context.GetScreenSpaceTemporaryRT();
            context.command.BlitFullscreenTriangle(
                context.source,
                renderTexture,
                sheet,
                0);

            sheet.properties.SetFloat("_Thickness", settings.thickness);
            sheet.properties.SetFloat("_Detect", settings.detect);
            sheet.properties.SetTexture("_ColourNormalsTex", renderTexture);
            context.command.BlitFullscreenTriangle(
                context.source,
                context.destination,
                sheet,
                1);

            RenderTexture.ReleaseTemporary(renderTexture);
        }
    }
}

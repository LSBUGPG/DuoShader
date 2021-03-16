using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[System.Serializable]
[PostProcess(typeof(PrintRenderer), PostProcessEvent.AfterStack, "Custom/Print")]
public class Print : PostProcessEffectSettings
{
    [Range(0.0f, 1.0f), Tooltip("The input level cutoff between white and black")]
    public FloatParameter printBlackLevel = new FloatParameter
    {
        value = 0.75f
    };
    [Range(0.0f, 0.5f), Tooltip("Noise in the sampling process")]
    public FloatParameter sampleNoise = new FloatParameter
    {
        value = 0.1f
    };
    public ColorParameter inkColour = new ColorParameter
    {
        value = new Color(0.278f, 0.231f, 0.239f, 1.0f)
    };
    public ColorParameter paperColour = new ColorParameter
    {
        value = new Color(0.855f, 0.788f, 0.725f, 1.0f)
    };
}

public class PrintRenderer : PostProcessEffectRenderer<Print>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Print"));
        sheet.properties.SetFloat("_PrintBlackLevel", settings.printBlackLevel);
        sheet.properties.SetColor("_InkColour", settings.inkColour);
        sheet.properties.SetColor("_PaperColour", settings.paperColour);
        sheet.properties.SetFloat("_NoiseLevel", settings.sampleNoise);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}

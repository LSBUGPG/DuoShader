using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[System.Serializable]
[PostProcess(typeof(DuoShadeRenderer), PostProcessEvent.AfterStack, "Custom/DuoShade")]
public class DuoShader : PostProcessEffectSettings
{
    [Range(1f, 30f), Tooltip("Distance (pixels) between diagonal lines")]
    public FloatParameter frequency = new FloatParameter
    {
        value = 6f
    };
    [Range(0f, 1f), Tooltip("Thickness of the lines as a fraction of the distance")]
    public FloatParameter thickness = new FloatParameter
    {
        value = 0.4f
    };
    [Range(0f, 1f), Tooltip("Luma level of the source image considered black")]
    public FloatParameter black = new FloatParameter
    {
        value = 0.25f
    };
    [Range(0f, 1f), Tooltip("Luma level of the source image exposing both lines")]
    public FloatParameter dark = new FloatParameter
    {
        value = 0.4f
    };
    [Range(0f, 1f), Tooltip("Luma level of the source image exposing one line")]
    public FloatParameter light = new FloatParameter
    {
        value = 0.758f
    };
    [Tooltip("The output level difference between uncoloured and an undeveloped line")]
    public FloatParameter undevelopedLevel = new FloatParameter
    {
        value = 0.01f
    };
    [Tooltip("The output colour of a developed line")]
    public ColorParameter developedColour = new ColorParameter
    {
        value = new Color(0.258f, 0.282f, 0.282f, 1.0f)
    };
    [Tooltip("The output colour of an undeveloped line")]
    public ColorParameter undevelopedColour = new ColorParameter
    {
        value = new Color(0.839f, 0.914f, 0.961f, 1.0f)
    };
}

public class DuoShadeRenderer : PostProcessEffectRenderer<DuoShader>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/DuoShader"));
        sheet.properties.SetFloat("_Frequency", settings.frequency);
        sheet.properties.SetFloat("_Thickness", settings.thickness);
        sheet.properties.SetFloat("_Black", settings.black);
        sheet.properties.SetFloat("_Dark", settings.dark);
        sheet.properties.SetFloat("_Light", settings.light);
        sheet.properties.SetFloat("_UndevelopedLevel", settings.undevelopedLevel);
        sheet.properties.SetColor("_UndevelopedColour", settings.undevelopedColour);
        sheet.properties.SetColor("_DevelopedColour", settings.developedColour);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}

﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[System.Serializable]
[PostProcess(typeof(OutlineRenderer), PostProcessEvent.AfterStack, "Custom/Outline")]
public class Outline : PostProcessEffectSettings
{
    public FloatParameter thickness = new FloatParameter
    {
        value = 1.0f
    };
    [Range(0.0f, 1.0f)]
    public FloatParameter detect = new FloatParameter
    {
        value = 0.5f
    };
}

public class OutlineRenderer : PostProcessEffectRenderer<Outline>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(
            Shader.Find("Hidden/Custom/Outline"));

        RenderTexture renderTexture = context.GetScreenSpaceTemporaryRT();
        context.command.BlitFullscreenTriangle(
            context.source,
            renderTexture,
            sheet,
            0);

        sheet.properties.SetFloat("_Thickness", settings.thickness);
        sheet.properties.SetFloat("_Detect", settings.detect);
        context.command.BlitFullscreenTriangle(
            renderTexture,
            context.destination,
            sheet,
            1);

        RenderTexture.ReleaseTemporary(renderTexture);
    }
}

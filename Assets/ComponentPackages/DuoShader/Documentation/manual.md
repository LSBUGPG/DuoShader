# DuoShader

An attempt to create a Duotone / Duoshade effect similar to the old comic book printing style. This is a full-screen effect shader, so it needs to be applied to your camera render with a script.

## Material Properties

- `Frequency` represents the approximate width of the diagonal lines in screen pixels
- `Level` adjust the thickness of the duoshade lines in the range from 0 to 1 as a fraction of the `Frequency`
- `Width` is the width of the outline in pixels
- `Tones` represents the luma levels at which the effects start:
  - 0 - X black
  - X - Y two diagonal stripes
  - Y - Z one diagonal stripes
  - Z - 1 white
  - W - the difference in colour required for a line to inferred

## Example Scene

This component contains the shader, a material, and a script to apply it to the camera. To add this effect to your scene, assign the ScreenEffect script to your camera and choose the DuoShader material as the `screenEffect`.

## Customisation

If you already have your own script that applies a `Graphics.Blit` to the camera, you can substitute it for the script supplied here. And if you already have a `Material` assigned for use you can substitute that as well by simply selecting `ScreenEffect/DuoShader` as the shader for your material.

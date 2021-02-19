# DuoShader

An attempt to create a Duotone / Duoshade effect similar to the old comic book printing style. This is a full-screen effect shader, so it needs to be applied to your camera render with a script.

## Material Properties

- `Frequency` represents the approximate width of the diagonal lines in screen pixels
- `Level` adjust the thickness of the duoshade lines in the range from 0 to 1 as a fraction of the `Frequency`
- `Edge` the thickness of the blended edge of the duoshade line as above
- `Black` represents the black level
- `Low` one diagonal stripe
- `High` two diagonal stripes

## Example Scene

This component contains the shader, a material, and a script to apply it to the camera. To add this effect to your scene, assign the ScreenEffect script to your camera and choose the DuoShader material as the `screenEffect`.

I have added the Toon shader components from the Unity Essentials pack to provide the outline and quantised colour.

## Customisation

If you already have your own script that applies a `Graphics.Blit` to the camera, you can substitute it for the script supplied here. And if you already have a `Material` assigned for use you can substitute that as well by simply selecting `ScreenEffect/DuoShader` as the shader for your material.

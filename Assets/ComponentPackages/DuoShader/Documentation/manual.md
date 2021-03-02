# DuoShader

An attempt to recreate a Duotone / Duoshade effect similar to the old black and white comic book printing technique made famous in Teenage Mutant Ninja Turtles, 1984.

![Teenage Mutant Ninja Turtles #1, 1984](./turtles.png)

At first glance it looks like this is printing with 4 shades: black, dark, light, white. But a closer zoom reveals that the shades are made by fine diagonal stripes in black ink.

![Close up](./zoom.png)

This effect was achieved by the artist before printing by using a special type of paper with pre-printed diagonal lines. The lines appear in a very light blue ink which does not get picked up in the printing process. There are also two chemical paints, one which darkens one set of the diagonal lines, and another which darkens both.

Here is [a video of the process in action](https://youtu.be/GftgBL-sHnI).

## How to use this shader

This package contains two PostProcess shader effects for Unity's PostProcessing 2.0 package, so you need to have the PostProcessing 2.0 package installed and configured for your project.

### Duo Shader effect

This effect takes your source and emulates having drawn it on a DuoShade board. It has a number of parameter for configuring your output image.

- `Frequency` the distance in pixels between diagonal lines
- `Thickness` the thickness of the lines as a fraction of their distance
- `Black` the luma level of the source image considered black
- `Dark` the luma level of the source image exposing both lines
- `Light` the luma level of the source image exposing one line
- `Undeveloped Level` the difference between unpainted paper and an unexposed line
- `Undeveloped Colour` the colour of undeveloped lines
- `Developed Colour` the colour of developed lines

### Print effect

This effect emulates making a black and white print from your source image. It simply paints every pixel white or black depending on the black level.

- `PrintBlackLevel` the luma level at the output stage considered black
- `Ink Colour` colour of the ink at the output stage
- `Paper Colour` colour of the paper at the output stage

## Example Scene

The example scene has a camera with PostProcessing effects applied. The example post-processing profile contains 3 effects applied in order.

First is the DuoShader which takes your image and emulates drawing it onto DuoShade board.

Next is the Unity grain effect which helps to feather out lighter areas of the duo shade effect.

The final step is the print effect.

I have also added the Toon shader components from the Unity Essentials pack to provide the outline and quantised colour in the source image.

And the last step is FXAA which helps to smooth out the diagonal lines in the duo shade effect.
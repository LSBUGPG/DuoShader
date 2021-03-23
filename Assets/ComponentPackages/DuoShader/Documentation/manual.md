# DuoShader

An attempt to recreate a Duotone / Duoshade effect similar to the old black and white comic book printing technique made famous in Teenage Mutant Ninja Turtles, 1984.

![Teenage Mutant Ninja Turtles #1, 1984](./turtles.png)

At first glance it looks like this is printing with 4 shades: black, dark, light, white. But a closer zoom reveals that the shades are made by fine diagonal stripes in black ink.

![Close up](./zoom.png)

This effect was achieved by the artist before printing by using a special type of paper with pre-printed diagonal lines. The lines appear in a very light blue ink which does not get picked up in the printing process. There are also two chemical paints, one which darkens one set of the diagonal lines, and another which darkens both.

Here is [a video of the process in action](https://youtu.be/GftgBL-sHnI).

## How to use these shaders

This package contains three PostProcess shader effects for Unity's PostProcessing 2.0 package, so you need to have the PostProcessing 2.0 package installed and configured for your project. Each shader emulates a part of the authoring or printing process.

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
- `Sample Noise` this helps to feather the transition between luma levels

### Print effect

This effect emulates making a black and white print from your source image. It paints every pixel as either the paper colour or the ink colour depending on the luma level of the source image.

- `Print Black Level` the luma level at the output stage considered for ink
- `Sample Noise` this helps to dither the transition between ink and paper
- `Ink Colour` colour of the ink
- `Paper Colour` colour of the paper

### Outline effect

This detects the edges of the source image. It does this first by colouring each face according to its normal, and then using an edge detection algorithm to mark the outline areas.

- `Thickness` this is the thickness of the outline
- `Detect` this is the detection sensitivity to a change in colour
- `Debug` this flag is for debugging the output to make sure faces are coloured according to their normals

This effect requires the depth normals camera texture so I have included a camera script to ensure that your camera is set to the correct mode.

## Example Scene

The example scene has a camera with PostProcessing effects applied. The example post-processing profile contains the three effects applied in the following order.

First, the outline effect is applied to draw an outline over the source image where is detects changes in the surface normal or colour.

Then the DuoShader is applied to create the hatching pattern for dark and light shades.

Finally, the print effect is applied to colour the image as either ink or paper.

FXAA has been applied to the post process layer to smooth out pixel edges, particularly around the noisy areas of the image.
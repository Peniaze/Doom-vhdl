from PIL import Image

im = Image.open('doom.jpg')

r, g, b = im.split()
width, height = im.size
for color in [r, g, b]:
    for x in range(width):
        for y in range(height):

            oldPixel = color.getpixel((x, y))

            newPixel = 0
            if (oldPixel > 120):
                newPixel = 255
            color.putpixel((x, y), newPixel)

            quant_error = oldPixel - newPixel
            if x < width - 1:
                color.putpixel((x + 1, y + 0), int(color.getpixel((x + 1, y + 0)) + quant_error * 7 / 16))
                if y < height - 1:
                    color.putpixel((x + 1, y + 1), int(color.getpixel((x + 1, y + 1)) + quant_error * 1 / 16))
            if y < height - 1:
                color.putpixel((x + 0, y + 1), int(color.getpixel((x + 0, y + 1)) + quant_error * 5 / 16))

im = Image.merge("RGB", (r, g, b))
im.save('doom_out.jpg')
im.show()

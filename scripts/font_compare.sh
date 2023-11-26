# Create an image with text in Font1
convert -size 300x100 xc:white -font "/usr/share/fonts/truetype/noto/NotoSans-Regular.ttf" -pointsize 24 -gravity center -annotate 0 "The quick brown fox jumps over the lazy dog" Font1.png

# Create an image with text in Font2
convert -size 300x100 xc:white -font "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf" -pointsize 24 -gravity center -annotate 0 "The quick brown fox jumps over the lazy dog" Font2.png

# Create an image with text in Font3
convert -size 300x100 xc:white -font "/usr/share/fonts/truetype/iosevka/iosevka-extendedoblique.ttf" -pointsize 24 -gravity center -annotate 0 "The quick brown fox jumps over the lazy dog" Font3.png

# Combine the images side-by-side
convert +append Font1.png Font2.png Font3.png Combined.png

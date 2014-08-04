# encoding: UTF-8
require File.join(File.dirname(__FILE__),'test_helper')
require 'test/unit'

def set_to_red(color)
  color[:red] = 255
  color[:green] = 0
  color[:blue] = 0
end

image = FreeImage::Bitmap.open('images/lena.png')
thumbnail = image.make_thumbnail(100)

# Make the bottom row red
scanline = thumbnail.scanline(0)

# Draw bottom border
(0..3).each do |index|
  scanline = thumbnail.scanline(index)
  scanline.each do |color|
    set_to_red(color)
  end
end

# Draw top border
((thumbnail.height - 5)..(thumbnail.height - 1)).each do |index|
  scanline = thumbnail.scanline(index)
  scanline.each do |color|
    set_to_red(color)
  end
end

# Draw left and right borders
(1..(thumbnail.height - 2)).each do |index|
  scanline = thumbnail.scanline(index)
  (0..4).each do |index|
    set_to_red(scanline[index])
  end

  ((thumbnail.width - 5)..(thumbnail.width - 1)).each do |index|
    set_to_red(scanline[index])
  end
end

thumbnail.save("images/lena_thumbnail_border_scanline.png", :png)

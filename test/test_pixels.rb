# encoding: UTF-8
require File.join(File.dirname(__FILE__),'test_helper')
require 'test/unit'

class PixelTest < Test::Unit::TestCase
  def test_bits
    bytes = sample_image.bits
    assert_not_nil(bytes)
  end

  def test_pixel_index
    index = sample_image.pixel_index(0, 0)
    assert_equal(113, index)

    index = lena_image.pixel_index(0, 0)
    assert_nil(index)
  end

  def test_set_pixel_index
    image = sample_image
    result = image.set_pixel_index(0, 0, 14)
    assert(result)

    index = image.pixel_index(0, 0)
    assert_equal(14, index)
  end

  def test_set_pixel_invalid
    image = lena_image
    result = image.set_pixel_index(0, 0, 14)
    assert(!result)
  end

  def test_pixel_color
    color = lena_image.pixel_color(0, 0)
    assert_kind_of(FreeImage::RGBQuad, color)

    color = sample_image.pixel_color(0, 0)
    assert_nil(color)
  end

  def test_set_pixel_color
    image = lena_image

    color1 = FreeImage::RGBQuad.create(0, 0, 255)
    result = image.set_pixel_color(0, 0, color1)
    assert(result)

    color2 = image.pixel_color(0, 0)
    assert_equal(color1, color2)
  end

  def test_set_pixel_invalid
    # Pixel colors aren't supported on paletted images
    image = sample_image

    color1 = FreeImage::RGBQuad.create(0, 0, 255)
    result = image.set_pixel_color(0, 0, color1)
    assert(!result)
  end
end

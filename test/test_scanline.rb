# encoding: UTF-8
require File.join(File.dirname(__FILE__),'test_helper')
require 'test/unit'

class ScanlineTest < Test::Unit::TestCase
  def scanline(index = 0)
    image = lena_image
    image.scanline(index)
  end

  def test_class
    assert_kind_of(FreeImage::Scanline, scanline)
  end

  def test_bytesize
    assert_equal(lena_image.pitch, scanline.bytesize)
  end

  def test_pixelsize
    assert_equal(lena_image.width, scanline.pixelsize)
  end

  def test_color_type
    assert_equal(FreeImage::RGBTriple, scanline.send(:color_type))
  end

  def test_color_size
    assert_equal(3, scanline.send(:color_type).size)
  end

  def test_color
    expected = lena_image.pixel_color(0, 0)
    actual = scanline[0]

    assert_equal(expected[:red], actual[:red])
    assert_equal(expected[:green], actual[:green])
    assert_equal(expected[:blue], actual[:blue])
    assert_equal(expected[:reserved], 0)
  end

  def test_invalid_y
    error = assert_raise(RangeError) do
      lena_image.scanline(-1)
    end
    assert_equal("Index must be between 0 and 511", error.to_s)

    error = assert_raise(RangeError) do
      lena_image.scanline(1000)
    end
    assert_equal("Index must be between 0 and 511", error.to_s)
  end

  def test_invalid_x
    error = assert_raise(RangeError) do
      scanline[-1]
    end
    assert_equal("Index must be between 0 and 511", error.to_s)

    error = assert_raise(RangeError) do
      scanline[1000]
    end
    assert_equal("Index must be between 0 and 511", error.to_s)
  end
end

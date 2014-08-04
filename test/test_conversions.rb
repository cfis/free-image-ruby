# encoding: UTF-8
require File.join(File.dirname(__FILE__),'test_helper')
require 'test/unit'

class ConverstionsTest < Test::Unit::TestCase
  def test_convert_to_4bits
    bitmap = sample_image.convert_to_4bits
    assert_kind_of(FreeImage::Bitmap, bitmap)
    assert_equal(4, bitmap.bits_per_pixel)
  end

  def test_convert_to_8bits
    bitmap = sample_image.convert_to_8bits
    assert_kind_of(FreeImage::Bitmap, bitmap)
    assert_equal(8, bitmap.bits_per_pixel)
  end

  def test_convert_to_greyscale
    bitmap = sample_image.convert_to_greyscale
    assert_kind_of(FreeImage::Bitmap, bitmap)
    assert_equal(8, bitmap.bits_per_pixel)
  end

  def test_convert_to_16bits_555
    bitmap = sample_image.convert_to_16bits_555
    assert_kind_of(FreeImage::Bitmap, bitmap)
    assert_equal(16, bitmap.bits_per_pixel)
  end

  def test_convert_to_16bits_565
    bitmap = sample_image.convert_to_16bits_565
    assert_kind_of(FreeImage::Bitmap, bitmap)
    assert_equal(16, bitmap.bits_per_pixel)
  end

  def test_convert_to_24bits
    bitmap = sample_image.convert_to_24bits
    assert_kind_of(FreeImage::Bitmap, bitmap)
    assert_equal(24, bitmap.bits_per_pixel)
  end

  def test_convert_to_32bits
    bitmap = sample_image.convert_to_32bits
    assert_kind_of(FreeImage::Bitmap, bitmap)
    assert_equal(32, bitmap.bits_per_pixel)
  end

  def test_convert_to_standard_type
    bitmap = sample_image.convert_to_standard_type
    assert_kind_of(FreeImage::Bitmap, bitmap)
    assert_equal(8, bitmap.bits_per_pixel)
  end

  def test_convert_to_type
    bitmap = sample_image.convert_to_type(:rgb16)
    assert_kind_of(FreeImage::Bitmap, bitmap)
    assert_equal(48, bitmap.bits_per_pixel)
  end

  def test_dither
    bitmap = sample_image.dither(:bayer4x4)
    assert_kind_of(FreeImage::Bitmap, bitmap)
    assert_equal(1, bitmap.bits_per_pixel)
  end

  def test_threshold
    bitmap = sample_image.threshold(7)
    assert_kind_of(FreeImage::Bitmap, bitmap)
    assert_equal(1, bitmap.bits_per_pixel)
  end

  def test_threshold_low
    error = assert_raise(RangeError) do
      sample_image.threshold(-1)
    end
    assert_equal("Value is out of range 0..255. Value: -1", error.message)
  end

  def test_threshold_hight
    error = assert_raise(RangeError) do
      sample_image.threshold(5555)
    end
    assert_equal("Value is out of range 0..255. Value: 5555", error.message)
  end
end

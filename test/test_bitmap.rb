# encoding: UTF-8

require './test_helper'
require 'test/unit'

class BitmapTest < Test::Unit::TestCase
  def test_bits
    bytes = sample_image.bits
    assert_equal(6466, bytes.size)

    if defined?(Encoding)
      assert_equal(Encoding::BINARY, bytes.encoding)
      assert_equal(bytes.size, bytes.bytesize)
    end
  end

  def test_open
    bitmap = FreeImage::Bitmap.open('images/lena.png')
    assert_kind_of(FreeImage::Bitmap, bitmap)
  end

  def test_open_yield
    result = FreeImage::Bitmap.open('images/lena.png') do |bitmap|
      assert_kind_of(FreeImage::Bitmap, bitmap)
    end
    assert_equal(true, result)
  end

  def test_open_yield_error
    assert_raise(ArgumentError) do
      FreeImage::Bitmap.open('images/lena.png') do |bitmap|
        raise(ArgumentError, "Let's mess things up")
      end
    end
  end

  def test_free
    1000.times do
      image = sample_image
      image.free
    end
  end
end

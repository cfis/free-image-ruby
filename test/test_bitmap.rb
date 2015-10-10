# encoding: UTF-8
require File.join(File.dirname(__FILE__),'test_helper')
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
    bitmap = FreeImage::Bitmap.open(image_path('lena.png'))
    assert_kind_of(FreeImage::Bitmap, bitmap)
  end

  def test_open_yield
    FreeImage::Bitmap.open(image_path('lena.png')) do |bitmap|
      assert_kind_of(FreeImage::Bitmap, bitmap)
    end
  end

  def test_open_yield_error
    assert_raise(ArgumentError) do
      FreeImage::Bitmap.open(image_path('lena.png')) do |bitmap|
        raise(ArgumentError, "Let's mess things up")
      end
    end
  end

  def test_new_from_nil
    ptr = FFI::Pointer::NULL
    error = assert_raise(FreeImage::Error) do
      FreeImage::Bitmap.new(ptr)
    end
    assert_equal("Cannot create a bitmap from a null pointer", error.message)
  end

  def test_clone
    image = lena_image
    clone = image.clone
    assert(!clone.equal?(image))
  end

  def test_clone_block
    lena_image.clone do |image|
      assert_not_nil(image)
    end
  end

  def test_free
    1000.times do
      image = sample_image
      image.free
    end
  end
end

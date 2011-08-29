# encoding: UTF-8

require './test_helper'
require 'test/unit'

class MemoryTest < Test::Unit::TestCase
  def memory(image = 'sample.png')
    data = image_data(image)
    FreeImage::Memory.new(data)
  end

  def test_wrap
    assert_not_nil(memory)
  end

  def test_format
    assert_equal(:png, memory.format)
  end

  def test_format_unknown
    assert_equal(:unknown, memory('not_an_image.txt').format)
  end

  def test_load
    bitmap = memory.open
    assert_kind_of(FreeImage::Bitmap, bitmap)
  end

  def test_load_unknown
    error = assert_raise(TypeError) do
      memory('not_an_image.txt').open
    end
    assert_equal("Unknown image format",
                 error.message)
  end

  def test_load_wrong_format
    error = assert_raise(FreeImage::FreeImageError) do
      memory.open(:jpeg, 0)
    end
    assert_equal("Not a JPEG file: starts with 0x89 0x50", error.to_s)
  end

  def test_bytes
    bitmap1 = FreeImage::Bitmap.open(image_path('sample.png'))

    memory = FreeImage::Memory.new(image_data('sample.png'))
    bitmap2 = memory.open

    assert_equal(bitmap1.bits, bitmap2.bits)
  end

  def test_save
    dst = FreeImage::Memory.new

    bitmap = memory.open
    result = bitmap.save(dst, :png)

    assert(result)
    assert_not_nil(dst.memory.bytes)
    if defined?(Encoding)
      assert_equal(dst.memory.bytes.encoding, Encoding::BINARY)
    end
  end
end
# encoding: UTF-8
require File.join(File.dirname(__FILE__),'test_helper')

class MemoryTest < Minitest::Test
  def memory(image = 'sample.png')
    data = image_data(image)
    FreeImage::Memory.new(data)
  end

  def test_wrap
    refute_nil(memory)
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
    error = assert_raises(FreeImage::Error) do
      memory('not_an_image.txt').open
    end
    assert_equal("Cannot load :unknown image format",
                 error.message)
  end

  def test_load_wrong_format
    error = assert_raises(FreeImage::Error) do
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
    dest = FreeImage::Memory.new

    bitmap = memory.open
    result = bitmap.save(dest, :png)
    assert(result)
    assert_equal(37115, dest.memory.count)
    refute_nil(dest.memory.bytes)
    assert_equal(37115, dest.memory.bytes.length)

    assert(result)
    if defined?(Encoding)
      assert_equal(dest.memory.bytes.encoding, Encoding::BINARY)
    end
  end

  def test_corrupt
    data = image_data('corrupt.jpg')
    memory = FreeImage::Memory.new(data)

    error = assert_raises(FreeImage::Error) do
      memory.open
    end
    assert_equal("Cannot load :unknown image format", error.message)
  end

  def test_corrupt_wrong_format
    data = image_data('corrupt.jpg')
    memory = FreeImage::Memory.new(data)

    error = assert_raises(FreeImage::Error) do
      memory.open(:png)
    end
    assert_equal("Could not load the image", error.message)
  end
end
# encoding: UTF-8

require './test_helper'
require 'test/unit'

class IoTest < Test::Unit::TestCase
  def io(image = 'sample.png')
    path = image_path(image)
    file = File.open(path)
    FreeImage::IO.new(file)
  end

  def test_format
    assert_equal(:png, io.format)
  end

  def test_format_unknown
    assert_equal(:unknown, io('not_an_image.txt').format)
  end

  def test_load
    bitmap = io.open
    assert_kind_of(FreeImage::Bitmap, bitmap)
  end

  def test_load_unknown
    error = assert_raise(TypeError) do
      io('not_an_image.txt').open
    end
    assert_equal("Unknown image format",
                 error.message)
  end

  def test_load_wrong_format
    error = assert_raise(FreeImage::Error) do
      io.open(:jpeg)
    end
    assert_equal("Not a JPEG file: starts with 0x89 0x50", error.to_s)
  end

  def test_save
    tmp_file = Tempfile.new('test_free_image')
    dst = FreeImage::IO.new(tmp_file)

    bitmap = io.open
    result = bitmap.save(dst, :png)
    assert(result)
    assert(File.exists?(tmp_file))
  ensure
    tmp_file.close
    tmp_file.unlink
  end
end
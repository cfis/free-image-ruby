# encoding: UTF-8
require File.join(File.dirname(__FILE__),'test_helper')
require 'test/unit'

class FIFileTest < Test::Unit::TestCase
  def file(image = 'sample.png')
    path = image_path(image)
    FreeImage::File.new(path)
  end

  def test_format
    assert_equal(:png, file.format)
  end

  def test_format_unknown
    assert_equal(:unknown, file('not_an_image.txt').format)
  end

  def test_load
    bitmap = file.open
    assert_kind_of(FreeImage::Bitmap, bitmap)
  end

  def test_load_format
    error = assert_raise(FreeImage::Error) do
      file('not_an_image.txt').open
    end
    assert_equal('Cannot load :unknown image format', error.to_s)
  end

  def test_load_wrong_format
    error = assert_raise(FreeImage::Error) do
      file.open(:jpeg)
    end
    assert_equal("Not a JPEG file: starts with 0x89 0x50", error.to_s)
  end

  def test_save
    tmp_file = Tempfile.new('test_free_image')
    dst = FreeImage::File.new(tmp_file.path)

    bitmap = file.open
    result = bitmap.save(dst, :png)
    assert(result)
    assert(File.exists?(tmp_file))
  ensure
    tmp_file.close
    tmp_file.unlink
  end

  def test_corrupt
    path = image_path('corrupt.jpg')
    file = FreeImage::File.new(path)
    error = assert_raise(FreeImage::Error) do
      file.open
    end
    assert_equal("Not a JPEG file: starts with 0xaa 0xc0", error.message)
  end

  def test_corrupt_wrong_format
    path = image_path('corrupt.jpg')
    file = FreeImage::File.new(path)
    error = assert_raise(FreeImage::Error) do
      # Be sneaky - say png!
      file.open(:png)
    end
    assert_equal("Could not load the image", error.message)
  end
end
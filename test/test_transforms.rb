# encoding: UTF-8
require File.join(File.dirname(__FILE__),'test_helper')
require 'test/unit'

class TrasformsTest < Test::Unit::TestCase
  def test_rotate
    bitmap1 = FreeImage::Bitmap.open(image_path('sample.png'))
    bitmap2 = bitmap1.rotate(45)
    assert_kind_of(FreeImage::Bitmap, bitmap2)
  end

  def test_rotate_ex
    bitmap1 = FreeImage::Bitmap.open(image_path('sample.png'))
    bitmap2 = bitmap1.rotate_ex(45, 0, 0, 0, 0)
    assert_kind_of(FreeImage::Bitmap, bitmap2)
  end

  def test_flip_horizontal
    bitmap1 = FreeImage::Bitmap.open(image_path('sample.png'))
    result = bitmap1.flip_horizontal!
    assert_kind_of(TrueClass, result)
  end

  def test_flip_vertical
    bitmap1 = FreeImage::Bitmap.open(image_path('sample.png'))
    result = bitmap1.flip_vertical!
    assert_kind_of(TrueClass, result)
  end
end
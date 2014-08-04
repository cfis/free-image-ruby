# encoding: UTF-8
require File.join(File.dirname(__FILE__),'test_helper')
require 'test/unit'

class ModifyTest < Test::Unit::TestCase
  def test_copy
    bitmap1 = FreeImage::Bitmap.open(image_path('sample.png'))
    bitmap2 = bitmap1.copy(0, 0, 50, 60)

    assert_kind_of(FreeImage::Bitmap, bitmap2)
    assert_equal(50, bitmap2.width)
    assert_equal(60, bitmap2.height)
  end

  def test_expand_canvas
    bitmap = FreeImage::Bitmap.open(image_path('sample.png'))
    color = FreeImage::RGBQuad.create(15, 30, 45)

    result = bitmap.enlarge_canvas(1, 1, 1, 1, color)
    assert_kind_of(FreeImage::Bitmap, result)
  end

  def test_fill_background
    bitmap = FreeImage::Bitmap.open(image_path('sample.png'))
    color = FreeImage::RGBQuad.create(15, 30, 45)

    result = bitmap.fill_background!(color)
    assert(result)
  end

  def test_paste
    bitmap1 = FreeImage::Bitmap.open(image_path('sample.png'))
    bitmap2 = FreeImage::Bitmap.open(image_path('sample.png'))
    result = bitmap1.paste!(bitmap2, 0, 0, 0.5)

    assert_kind_of(TrueClass, result)
    assert_equal(240, bitmap2.width)
    assert_equal(215, bitmap2.height)
  end

  def test_rescale
    bitmap1 = FreeImage::Bitmap.open(image_path('sample.png'))
    bitmap2 = bitmap1.rescale(120, 100, :box)

    assert_kind_of(FreeImage::Bitmap, bitmap2)
    assert_equal(120, bitmap2.width)
    assert_equal(100, bitmap2.height)
  end

  def test_thumbnail
    bitmap1 = FreeImage::Bitmap.open(image_path('sample.png'))
    bitmap2 = bitmap1.make_thumbnail(100)

    assert_kind_of(FreeImage::Bitmap, bitmap2)
    assert_equal(100, bitmap2.width)
    assert_equal(90, bitmap2.height)
  end
end
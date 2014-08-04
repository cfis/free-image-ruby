# encoding: UTF-8
require File.join(File.dirname(__FILE__),'test_helper')
require 'test/unit'

class PaletteTest < Test::Unit::TestCase
  def test_palette
    palette = sample_image.palette
    assert_not_nil(palette)
    assert_kind_of(FreeImage::Palette, palette)
  end

  def test_size
    palette = sample_image.palette
    assert_equal(256, palette.size)
  end

  def test_index
    palette = sample_image.palette
    rgb = palette[27]

    assert_kind_of(FreeImage::RGBQuad, rgb)
    assert_equal(201, rgb[:red])
    assert_equal(253, rgb[:green])
    assert_equal(0, rgb[:blue])
  end

  def test_index_too_small
    palette = sample_image.palette

    error = assert_raise(RangeError) do
      palette[-1]
    end
    assert_equal("Value is out of range 0..256. Value: -1", error.message)
  end

  def test_index_too_large
    palette = sample_image.palette

    error = assert_raise(RangeError) do
      palette[300]
    end
    assert_equal("Value is out of range 0..256. Value: 300", error.message)
  end
end

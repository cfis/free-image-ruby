# encoding: UTF-8
require File.join(File.dirname(__FILE__),'test_helper')
require 'test/unit'

class RGBQuadTest < Test::Unit::TestCase
  def test_create
    color = FreeImage::RGBQuad.create(1,2,3,4)
    assert_equal(color[:red], 1)
    assert_equal(color[:green], 2)
    assert_equal(color[:blue], 3)
    assert_equal(color[:reserved], 4)
  end

  def test_=
    color1 = FreeImage::RGBQuad.create(1,2,3,4)
    color2 = FreeImage::RGBQuad.create(1,2,3,4)
    assert_equal(color1, color2)
  end

  def test_eql
    color1 = FreeImage::RGBQuad.create(1,2,3,4)
    color2 = FreeImage::RGBQuad.create(1,2,3,4)
    assert(color1.eql?(color2))
  end
end
# encoding: UTF-8

require './test_helper'
require 'test/unit'

class FreeImageTest < Test::Unit::TestCase
  def test_copyright
    assert_equal("This program uses FreeImage, a free, open source image library supporting all common bitmap formats. See http://freeimage.sourceforge.net for details",
                 FreeImage.copyright)
  end
  
  def test_version
    assert_equal("3.15.1", FreeImage.version)
  end
end

# encoding: UTF-8

require './test_helper'
require 'test/unit'

class BitmapTest < Test::Unit::TestCase
  def test_bytes
    bytes = sample_image.bits
    assert_equal(6466, bytes.size)

    if defined?(Encoding)
      assert_equal(Encoding::BINARY, bytes.encoding)
      assert_equal(bytes.size, bytes.bytesize)
    end
  end
end

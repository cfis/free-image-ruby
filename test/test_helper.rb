# encoding: UTF-8

# To make testing/debugging easier, test within this source tree versus an installed gem
dir = File.dirname(__FILE__)
ROOT_DIR = File.expand_path(File.join(dir, '..'))
LIB_DIR = File.expand_path(File.join(ROOT_DIR, 'lib'))

$LOAD_PATH << LIB_DIR

require 'rubygems'
require 'free-image'
require 'tempfile'

def image_path(image)
  File.join(ROOT_DIR, 'test', 'images', image)
end

def image_data(image)
  path = File.join(ROOT_DIR, 'test', 'images', image)
  result = nil
  File.open(path, 'rb') do |file|
    result = file.read
  end
  result
end

def sample_image
  path = File.join(ROOT_DIR, 'test', 'images', 'sample.png')
  FreeImage::Bitmap.open(path)
end

def lena_image
  path = File.join(ROOT_DIR, 'test', 'images', 'lena.png')
  FreeImage::Bitmap.open(path)
end

def bit16_bmp(bitfield=nil)
  suffix = begin
    if bitfield == 555
      'bf555'
    elsif bitfield == 565
      'bf565'
    else
      ''
    end
  end
  path = File.join(ROOT_DIR, 'test', 'images', "test16#{suffix}.bmp")
  FreeImage::Bitmap.open(path)
end
# encoding: UTF-8

module FreeImage
  # Used to specify a color for a :rgbaf
  # {image type}[rdoc-ref:FreeImage.images_types].
  class RGBAF < FFI::Struct
    layout :red, :float,
           :green, :float,
           :blue, :float,
           :alpha, :float
  end
end
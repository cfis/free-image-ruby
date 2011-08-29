# encoding: UTF-8

module FreeImage
  # Used to specify a color for a :rgbf
  # {image type}[rdoc-ref:FreeImage.images_types].
  class RGBF < FFI::Struct
    layout :red, :float,
           :green, :float,
           :blue, :float
  end
end
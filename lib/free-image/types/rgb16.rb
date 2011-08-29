# encoding: UTF-8

module FreeImage
  # Used to specify a color for a :rgb16
  # {image type}[rdoc-ref:FreeImage.images_types].
  class RGB16 < FFI::Struct
    layout :red, :word,
           :green, :word,
           :blue, :word
  end
end
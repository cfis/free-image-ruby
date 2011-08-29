# encoding: UTF-8

module FreeImage
  # Used to specify a color for a :rgb16a
  # {image type}[rdoc-ref:FreeImage.images_types].
  class RGBA16 < FFI::Struct
    layout :red, :word,
           :green, :word,
           :blue, :word,
           :alpha, :word
  end
end
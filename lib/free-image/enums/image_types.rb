#  encoding: UTF-8

module FreeImage
  ##
  # FreeImage supports the following image types:
  #
  # :unknown:: Unknown format (returned value only, never use it as input value)
  # :bitmap:: Standard image: 1-, 4-, 8-, 16-, 24-, 32-bit
  # :uint16:: Array of unsigned short: unsigned 16-bit
  # :int16:: Array of short: signed 16-bit
  # :uint32:: Array of unsigned long: unsigned 32-bit
  # :int32:: Array of long: signed 32-bit
  # :float:: Array of float: 32-bit IEEE floating point
  # :double:: Array of double: 64-bit IEEE floating point
  # :complex:: Array of FICOMPLEX: 2 x 64-bit IEEE floating point
  # :rgb16:: 48-bit rgb image: 3 x 16-bit
  # :rgba16:: 64-bit rgba image: 4 x 16-bit
  # :rgbf:: 96-bit rgb float image: 3 x 32-bit IEEE floating point
  # :rgbaf:: 128-bit rgba float image: 4 x 32-bit IEEE floating point
  #
  # :method: image_types
  
  FreeImage.enum :image_type, [:unknown,
                               :bitmap,
                               :uint16,
                               :int16,
                               :uint32,
                               :int32,
                               :float,
                               :double,
                               :complex,
                               :rgb16,
                               :rgba16,
                               :rgbf,
                               :rgbaf]
end
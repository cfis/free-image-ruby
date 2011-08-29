# encoding: UTF-8

module FreeImage
  ##
  # FreeImage supports the following color types:
  # 
  # :minis_black:: Monochrome bitmap (1-bit) -> first palette entry is black.
  #                Palletised bitmap (4 or 8-bit) and single channel non standard bitmap -> the bitmap has a greyscale palette
  # :minis_white:: Monochrome bitmap (1-bit) -> first palette entry is white.
  #                Palletised bitmap (4 or 8-bit) and single channel non standard bitmap -> the bitmap has an inverted greyscale palette
  # :palette::     Palettized bitmap (1, 4 or 8 bit)
  # :rgb::         High-color bitmap (16, 24 or 32 bit), RGB16 or RGBF
  # :rgb_alpha::   High-color bitmap with an alpha channel (32 bit bitmap, RGBA16 or RGBAF)
  # :cmyk::        CMYK bitmap (32 bit only)
  #
  # :method: color_types
  
  FreeImage.enum :color_type, [:minis_white, 0,
                               :minis_black, 1,
                               :rgb, 2,
                               :palette, 3,
                               :rgb_alpha, 4,
                               :cmyk, 5]
end
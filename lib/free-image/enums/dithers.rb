#  encoding: UTF-8

module FreeImage
  ##
  # FreeImage supports the following dithering algorithms:
  #
  # :fs::           Floyd & Steinberg error diffusion algorithm
  # :bayer4x4::     Bayer ordered dispersed dot dithering (order 2 – 4x4 -dithering matrix)
  # :bayer8x8::     Bayer ordered dispersed dot dithering (order 3 – 8x8 -dithering matrix)
  # :bayer16x16::   Bayer ordered dispersed dot dithering (order 4 – 16x16 dithering matrix)
  # :cluster6x6::   Ordered clustered dot dithering (order 3 - 6x6 matrix)
  # :cluster8x8::   Ordered clustered dot dithering (order 4 - 8x8 matrix)
  # :cluster16x16:: Ordered clustered dot dithering (order 8 - 16x16 matrix)
  #
  # :method: dithers
  
  FreeImage.enum :dither, [:fs, 0,
                           :bayer4x4, 1,
                           :bayer8x8, 2,
                           :cluster6x6, 3,
                           :cluster8x8, 4,
                           :cluster16x16, 5,
                           :bayer16x16, 6]
end
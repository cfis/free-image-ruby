module FreeImage
  ##
  #FreeImage supports the following rescaling filters:
  #
  # :method: filters
  enum :filter, [:box, 0,
                 :bicubic, 1,
                 :bilinear, 2,
                 :bspline, 3,
                 :catmullrom, 4,
                 :lanczos3, 5]
end
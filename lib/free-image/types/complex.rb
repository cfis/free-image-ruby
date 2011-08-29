# encoding: UTF-8

module FreeImage
  # Structure for COMPLEX type (complex number) images
  class Complex < FFI::Struct
    layout :r, :double,
           :i, :double
  end
end
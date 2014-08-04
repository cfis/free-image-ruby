# encoding: UTF-8

module FreeImage
  # Used to specify a color for a :rgb16
  # {image type}[rdoc-ref:FreeImage.images_types].
  class RGB16 < FFI::Struct
    layout :red, :word,
           :green, :word,
           :blue, :word
    # The high order bit in 16-bit 555 is empty
    # Define masks to extract colors from bytes
    if FFI::Platform::BYTE_ORDER == FFI::Platform::LITTLE_ENDIAN
      # Little Endian (x86 / MS Windows, Linux, MacOSX) : BGR(A) order
      RED_MASK =   0x7C00
      GREEN_MASK = 0x03E0
      BLUE_MASK =  0x001F
    else
      # Big Endian (PPC / Linux, MaxOSX) : RGB(A) order
      RED_MASK =   0x003E
      GREEN_MASK = 0x07C0
      BLUE_MASK =  0xF800
    end
    RGB_MASK  = (RED_MASK | GREEN_MASK | BLUE_MASK)

  end

  class RGB16BF565 < RGB16
    # The 565 bitfield uses 16 bits, with 6 bits for Green
    if FFI::Platform::BYTE_ORDER == FFI::Platform::LITTLE_ENDIAN
      # Little Endian (x86 / MS Windows, Linux, MacOSX) : BGR(A) order
      RED_MASK =   0xF800
      GREEN_MASK = 0x07E0
      BLUE_MASK =  0x001F
    else
      # Big Endian (PPC / Linux, MaxOSX) : RGB(A) order
      RED_MASK =   0x001F
      GREEN_MASK = 0x03E0
      BLUE_MASK =  0xFC00
    end
    RGB_MASK  = (RED_MASK | GREEN_MASK | BLUE_MASK)
  end
end
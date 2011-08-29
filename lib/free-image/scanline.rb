module FreeImage
  #DLL_API BYTE *DLL_CALLCONV FreeImage_GetScanLine(FIBITMAP *dib, int scanline);
  attach_function('FreeImage_GetScanLine', [:pointer, :int], :pointer)

  # == Summary
  # Scanlines provide low level access to image data.
  # The only lower-level access is working with the actual raw bytes, which you can do
  # via the FreeeImage::Bitmap#bytes method, but its not recommended.
  #
  # A scanline represents one row of image data, starting from the bottom. You can
  # get a scanline via the Freeimage::Pixels#scanline method.
  #
  # To understand how scanlines work, you have to first understand that image data
  # is stored differently depending on the {image type}[FreeImage.image_types]
  # and the {bits per pixel}[FreeImage::Information#bits_per_pixel].  Thus, when
  # you call reeImage::Scanline#[] with an index, you will get back a different 
  # object depending on the image type and bit depth.
  #
  # In a :bitmap image, possible bit depths are 1-, 4-, 8-, 16-, 24-, 32-, 48-,
  # 64-, 96- and 128-bit. 
  #
  # * 1-bit DIBs are stored using each bit as an index into the color table. The most
  #   significant bit is the leftmost pixel. This is not currently supported.
  # * 4-bit DIBs are stored with each 4 bits representing an index into the color table. The
  #   most significant nibble is the leftmost pixel.  This is not currently supported.
  # * 8-bit DIBs are the easiest to store because each byte is an index into the color table.
  #   This is not currently supported.
  # * 24-bit DIBs have every 3 bytes representing a color, using the same ordering as the
  #   RGBTRIPLE structure.  Colors are represented using FreeImage::RGBTriple.
  # * 32-bit DIB have every 4 bytes representing a color associated to a alpha value (used
  #   to indicate transparency). Colors are represented using FreeImage::RGBTriple.
  #
  # Non standard image types such as short, long, float or double do not have a color
  # table. Pixels are stored in a similar way as 8-bit DIB.
  # 
  # Complex image types are stored in a similar way as 24- or 32bit DIB.  Colors are
  # represented using FreeImage::Complex.
  #
  # 16-bit RGB[A] image types are stored in a similar way as 24-bit
  # DIBs. Colors are represented using FreeImage::RGB16 or FreeImage::RFBA16.
  # 
  # Float RGB[A] image types are stored in a similar way 32bit
  # DIBs. Colors are represented using FreeImage::RGBF or FreeImage::RFBAF.
  #
  class Scanline
    include Enumerable

    # Creates a new scanline instance
    #
    # == Parameters
    # bitmap:: An instance of FreeImage::Bitmap
    # index:: The index of the scanline, must be between 0 and the image
    #         pixel heigh minus one.
    # ptr:: A pointer to the raw pixel data.
    #
    # Generally you do not want to call this method directly.  Instead, use
    # FreeImage::Bitmap#scanline.
    #
    def initialize(bitmap, index, ptr)
      @bitmap = bitmap
      @index = index
      @ptr = ptr
    end

    # Returns the appropriate color object for the image type and
    # bit depth.  See notes for the FreeImage::Scanline class.
    #
    # == Parameters
    # index:: The index of the scanline, must be between 0 and the image
    #         pixel width minus one.
    #
    # Returns the appropriate object for manipulating the data.
    #
    def [](index)
      unless (0...pixelsize).include?(index)
        raise(RangeError, "Index must be between 0 and #{pixelsize - 1}")
      end
      bytes_per_pixel = @bitmap.bits_per_pixel/8

      # Now get the address of the pixel
      address = @ptr.address + (index * bytes_per_pixel)

      # Now get a pointer to the pixel
      ptr = FFI::Pointer.new(bytes_per_pixel, address)

      # Now return a nice object to work with
      color_type.new(ptr)
    end

    # The width of the image in pixels.  Same as FreeImage::Bitmap#width.
    #
    def pixelsize
      @bitmap.width
    end
    
    # The width of the image in bytes.  Same as FreeImage::Bitmap#pitch.
    #
    def bytesize
      @bitmap.pitch
    end

    # Iterate over each pixel, returning the appropriate object to manipulate
    # the underlying data.
    #
    def each
      pixelsize.times do |i|
        yield (self[i])
      end
    end

    private

    def color_type
      case @bitmap.image_type
      when :bitmap
        case @bitmap.bits_per_pixel
        when 24
          RGBTriple
        when 32
          RGBQuad
        else
          raise(ArgumentError, "Not Supported")
        end
      when :uint16
        FFI::UINT16
      when :int16
        FFI::INT16
      when :uint32
        FFI::UINT32
      when :int32
        FFI::INT16
      when :float
        FFI::FLOAT
      when :double
        FFI::DOUBLE
      when :complex
        Complex
      when :rgb16
        RGB16
      when :rgba16
        RGBA16
      when :rgbf
        RGBF
      when :rgbaf
        RGBAF
      else
        raise(ArgumentError, "Not Supported")
      end
    end
  end
end
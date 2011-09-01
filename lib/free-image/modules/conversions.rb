module FreeImage
  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertTo4Bits(FIBITMAP *dib);
  attach_function('FreeImage_ConvertTo4Bits', [:pointer], :pointer)

  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertTo8Bits(FIBITMAP *dib);
  attach_function('FreeImage_ConvertTo8Bits', [:pointer], :pointer)

  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertToGreyscale(FIBITMAP *dib);
  attach_function('FreeImage_ConvertToGreyscale', [:pointer], :pointer)

  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertTo16Bits555(FIBITMAP *dib);
  attach_function('FreeImage_ConvertTo16Bits555', [:pointer], :pointer)

  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertTo16Bits565(FIBITMAP *dib);
  attach_function('FreeImage_ConvertTo16Bits565', [:pointer], :pointer)

  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertTo24Bits(FIBITMAP *dib);
  attach_function('FreeImage_ConvertTo24Bits', [:pointer], :pointer)

  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertTo32Bits(FIBITMAP *dib);
  attach_function('FreeImage_ConvertTo32Bits', [:pointer], :pointer)

  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Dither(FIBITMAP *dib, FREE_IMAGE_DITHER algorithm);
  attach_function('FreeImage_Dither', [:pointer, :dither], :pointer)

  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Threshold(FIBITMAP *dib, BYTE T);
  attach_function('FreeImage_Threshold', [:pointer, :byte], :pointer)

  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertToStandardType(FIBITMAP *src, BOOL scale_linear FI_DEFAULT(TRUE));
  attach_function('FreeImage_ConvertToStandardType', [:pointer, FreeImage::Boolean], :pointer)

  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertToType(FIBITMAP *src, FREE_IMAGE_TYPE dst_type, BOOL scale_linear FI_DEFAULT(TRUE));
  attach_function('FreeImage_ConvertToType', [:pointer, :image_type, FreeImage::Boolean], :pointer)

  module Conversions
    # :call-seq:
    #   image.convert_to_4bits -> bitmap
    #   image.convert_to_4bits {|img| block} -> bitmap
    #
    # Converts a bitmap to 4 bits. If the bitmap is a high-color (16, 24 or 32-bit),
    # monochrome or greyscale bitmap (1 or 8-bit) the end result will be a greyscale bitmap.
    # A 1-bit bitmap will become a palletized bitmap. 
    # 
    # Note that "greyscale" means that the resulting bitmap will have grey colors,
    # but the palette won't be a linear greyscale palette. Thus, FreeImage::Bitmap.color_type
    # will return a :palette.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def convert_to_4bits(&block)
      ptr = FreeImage.FreeImage_ConvertTo4Bits(self)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # :call-seq:
    #   image.convert_to_8bits -> bitmap
    #   image.convert_to_8bits {|img| block} -> bitmap
    #
    # Converts a bitmap to 8 bits. If the bitmap is a high-color (16, 24 or 32-bit),
    # monochrome or greyscale bitmap (1 or 4-bit) the end result will be a greyscale bitmap.
    # A 1-bit or 4-bit bitmap will become a palletized bitmap.
    #
    # For 16-bit greyscale images (images whose type is :uint16), conversion is done by
    # dividing the 16-bit channel by 256 (see also FreeImage::Bitmap.ConvertToStandardType).
    # A nil value is returned for other non-standard bitmap types.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def convert_to_8bits(&block)
      ptr = FreeImage.FreeImage_ConvertTo8Bits(self)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # :call-seq:
    #   image.convert_to_greyscale -> bitmap
    #   image.convert_to_greyscale {|img| block} -> bitmap
    #
    # Converts a bitmap to a 8-bit greyscale image with a linear ramp. Contrary to
    # the FreeImage::Conversions#convert_to_8bits function, 1-, 4- and 8-bit palletized
    # bitmaps are correctly converted, as well as images with a :minis_white color type.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def convert_to_greyscale(&block)
      ptr = FreeImage.FreeImage_ConvertToGreyscale(self)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # :call-seq:
    #   image.convert_to_16bits_555 -> bitmap
    #   image.convert_to_16bits_555 {|img| block} -> bitmap
    #
    # Converts a bitmap to 16 bits, where each pixel has a color pattern of
    # 5 bits red, 5 bits green and 5 bits blue. One bit in each pixel is
    # unused.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def convert_to_16bits_555(&block)
      ptr = FreeImage.FreeImage_ConvertTo16Bits555(self)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # :call-seq:
    #   image.convert_to_16bits_565 -> bitmap
    #   image.convert_to_16bits_565 {|img| block} -> bitmap
    #
    # Converts a bitmap to 16 bits, where each pixel has a color pattern of
    # 5 bits red, 6 bits green and 5 bits blue. One bit in each pixel is
    # unused.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def convert_to_16bits_565(&block)
      ptr = FreeImage.FreeImage_ConvertTo16Bits565(self)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # :call-seq:
    #   image.convert_to_24bits -> bitmap
    #   image.convert_to_24bits {|img| block} -> bitmap
    #
    # Converts a bitmap to 24 bits. For 48-bit RGB images, conversion is done
    # by dividing each 16-bit channel by 256. A nil value is returned for
    # other non-standard bitmap types.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def convert_to_24bits(&block)
      ptr = FreeImage.FreeImage_ConvertTo24Bits(self)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # :call-seq:
    #   image.convert_to_32bits -> bitmap
    #   image.convert_to_32bits {|img| block} -> bitmap
    #
    # Converts a bitmap to 32 bits. For 48-bit RGB images, conversion is done
    # by dividing each 16-bit channel by 256 and by setting the alpha channel
    # to an opaque value (0xFF). For 64-bit RGBA images, conversion is done
    # by dividing each 16-bit channel by 256. A nil value is returned for
    # other non-standard bitmap types.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def convert_to_32bits(&block)
      ptr = FreeImage.FreeImage_ConvertTo32Bits(self)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # :call-seq:
    #   image.convert_to_standard_type(scale_linear = true) -> bitmap
    #   image.convert_to_standard_type(scale_linear = true) {|img| block} -> bitmap
    #
    # Converts a non standard image whose color type is :minis_black to a
    # standard 8-bit greyscale image.  When the scale_linear parameter is
    # true, conversion is done by scaling linearly each pixel value from [min, max]
    # to an integer value between [0..255], where min and max are the minimum
    # and maximum pixel values in the image. When scale_linear is false, conversion
    # is done by rounding each pixel value to an integer between [0..255]. Rounding
    # is done using the following formula:
    #
    #  dst_pixel = (BYTE) MIN(255, MAX(0, q)) where int q = int(src_pixel + 0.5)
    #
    # For standard bitmaps, a clone of the original bitmap is returned.
    # For complex images, the magnitude is extracted as a double image and then converted
    # according to the scale parameter.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def convert_to_standard_type(scale_linear = true, &block)
      ptr = FreeImage.FreeImage_ConvertToStandardType(self, scale_linear)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # :call-seq:
    #   image.convert_to_type(dst_image_type, scale_linear = true) -> bitmap
    #   image.convert_to_type(dst_image_type, scale_linear = true) {|img| block} -> bitmap
    #
    # Converts a bitmap to the specified destination image type.  When the image_type
    # is equal to :bitmap, the function calls FreeImage::Converstions#convert_to_standard_type.
    # Otherwise, conversion is done using standard C language casting conventions. When
    # a conversion is not allowed, a nil value is returned and an error is thrown.
    # Please refer to the FreeImage documentation for allowed conversions.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def convert_to_type(dst_image_type, scale_linear = true, &block)
      ptr = FreeImage.FreeImage_ConvertToType(self, dst_image_type, scale_linear)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # :call-seq:
    #   image.dither(algorithm) -> bitmap
    #   image.dither(algorithm) {|img| block} -> bitmap
    #
    # Converts a bitmap to 1-bit monochrome bitmap using the specified
    # {dithering}[rdoc-ref:FreeImage.dithers] algorithm. For 1-bit input
    # bitmaps, the function clones the input bitmap and builds a
    # monochrome palette.  Otherwise the function first converts the
    # bitmap to a 8-bit greyscale bitmap.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def dither(algorithm, &block)
      ptr = FreeImage.FreeImage_Dither(self, algorithm)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # :call-seq:
    #   image.threshold(value) -> bitmap
    #   image.threshold(value) {|img| block} -> bitmap
    #
    # Converts a bitmap to 1-bit monochrome bitmap using a threshold value
    # between 0 and 255.  The function first converts the bitmap to a 8-bit
    # greyscale bitmap. Then any brightness level that is less than the
    # threshold is set to zero and any value above is set to 1.
    # For 1-bit input bitmaps, the function clones the input bitmap and
    # builds a monochrome palette.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def threshold(value, &block)
      value = Integer(value)
      unless (0..255).include?(value)
        raise(RangeError, "Value is out of range 0..255. Value: #{value}")
      end
      ptr = FreeImage.FreeImage_Threshold(self, value)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end
  end
end
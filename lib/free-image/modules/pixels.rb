module FreeImage
  #DLL_API BYTE *DLL_CALLCONV FreeImage_GetBits(FIBITMAP *dib);
  attach_function('FreeImage_GetBits', [:pointer], :pointer)
  
  #DLL_API BYTE *DLL_CALLCONV FreeImage_GetScanLine(FIBITMAP *dib, int scanline);
  attach_function('FreeImage_GetScanLine', [:pointer, :int], :pointer)

  #DLL_API BOOL DLL_CALLCONV FreeImage_GetPixelIndex(FIBITMAP *dib, unsigned x, unsigned y, BYTE *value);
  attach_function('FreeImage_GetPixelIndex', [:pointer, :uint, :uint, :pointer], FreeImage::Boolean)

  #DLL_API BOOL DLL_CALLCONV FreeImage_SetPixelIndex(FIBITMAP *dib, unsigned x, unsigned y, BYTE *value);
  attach_function('FreeImage_SetPixelIndex', [:pointer, :uint, :uint, :pointer], FreeImage::Boolean)

  #DLL_API BOOL DLL_CALLCONV FreeImage_GetPixelColor(FIBITMAP *dib, unsigned x, unsigned y, RGBQUAD *value);
  attach_function('FreeImage_GetPixelColor', [:pointer, :uint, :uint, :pointer], FreeImage::Boolean)

  #DLL_API BOOL DLL_CALLCONV FreeImage_SetPixelColor(FIBITMAP *dib, unsigned x, unsigned y, RGBQUAD *value);
  attach_function('FreeImage_SetPixelColor', [:pointer, :uint, :uint, :pointer], FreeImage::Boolean)

  # == Summary
  # 
  # The \Pixel module provides methods that allow you to read, write and work pixel-by-pixel
  # with image data. \FreeImage not only can work with standard bitmap data
  # (e.g. 1-, 4-, 8-, 16-, 24- and 32-bit) but also with scientific data such as
  # 16-bit greyscale images, or images made up of long, double or complex values
  # (often used in signal and image processing algorithms).
  #
  # The \FreeImage coordinate system is upside down relative to usual graphics
  # conventions. Thus, the scanlines are stored upside down, with the first
  # scan in memory being the bottommost scan in the image.
  #
  # For additional information, please refer to the FreeImage::Scanline documentation.
  #
  module Pixels
    # Returns the data-bits of the bitmap. It is up to you to interpret these bytes
    # correctly, according to the results of Information#bits_per_pixel, Information#red_mask,
    # Information#green_mask and Information#blue_mask.
    #
    # If the bitmap does not contain pixel data (see Information#has_pixels),
    # nil will be returned.
    #
    # For a performance reason, the address returned by FreeImage_GetBits is aligned on
    # a 16 bytes alignment boundary
    #
    def bits
      ptr = FreeImage.FreeImage_GetBits(self)
      FreeImage.check_last_error
      ptr.read_string
    end

    # Returns the requested row of image data as a FreeImage::Scanline instance.
    #
    # If the bitmap does not contain pixel data (see Information#has_pixels),
    # nil will be returned.
    def scanline(index)
      unless (0...self.height).include?(index)
        raise(RangeError, "Index must be between 0 and #{self.height - 1}")
      end
      ptr = FreeImage.FreeImage_GetScanLine(self, index)
      FreeImage.check_last_error

      ptr ? Scanline.new(self, index, ptr) : nil
    end

    # Gets the pixel index of a palettized image at the specified coordinate.
    #
    # == Parameters
    # x:: The pixel position in horizontal direction
    # y:: The pixel position in vertical direction.
    #
    def pixel_index(x, y)
      byte_type = FreeImage.find_type(:byte)
      ptr = FFI::MemoryPointer.new(byte_type)
      result = FreeImage.FreeImage_GetPixelIndex(self, x, y, ptr)
      FreeImage.check_last_error
      return nil unless result
      
      data = ptr.read_bytes(byte_type.size)
      if byte_type.size == 1
        data.ord
      else
        data
      end
    end

    # Sets the pixel index of a palettized image at the specified coordinate.
    #
    # == Parameters
    # x:: The pixel position in horizontal direction
    # y:: The pixel position in vertical direction.
    #
    # The function returns true on success and false otherwise.
    #
    def set_pixel_index(x, y, index)
      byte_type = FreeImage.find_type(:byte)
      ptr = FFI::MemoryPointer.new(byte_type.size)
      if byte_type.size == 1
        ptr.put_bytes(0, index.chr, 0, byte_type.size)
      else
        ptr.put_bytes(0, index.to_s, 0, byte_type.size)
      end
      result = FreeImage.FreeImage_SetPixelIndex(self, x, y, ptr)
      FreeImage.check_last_error
      result
    end

    # Gets the pixel color of a 16-, 24- or 32-bit image at the specified coordinate.
    #
    # == Parameters
    # x:: The pixel position in horizontal direction
    # y:: The pixel position in vertical direction.
    #
    def pixel_color(x, y)
      color = RGBQuad.new
      result = FreeImage.FreeImage_GetPixelColor(self, x, y, color)
      FreeImage.check_last_error
      result ? color : nil
    end

    # Sets the pixel color of a 16-, 24- or 32-bit image at the specified coordinate.
    #
    # == Parameters
    # x:: The pixel position in horizontal direction
    # y:: The pixel position in vertical direction.
    # color:: The new color as a RGBAQuad instance.
    #
    # The function returns true on success and false otherwise.
    #
    def set_pixel_color(x, y, color)
      result = FreeImage.FreeImage_SetPixelColor(self, x, y, color)
      FreeImage.check_last_error
      result
    end
  end
end
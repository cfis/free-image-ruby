module FreeImage
  #DLL_API BOOL DLL_CALLCONV FreeImage_HasPixels(FIBITMAP *dib);
  attach_function('FreeImage_HasPixels', [:pointer], FreeImage::Boolean)

  #DLL_API FREE_IMAGE_TYPE DLL_CALLCONV FreeImage_GetImageType(FIBITMAP *dib)
  attach_function('FreeImage_GetImageType', [:pointer], :image_type)

  #DLL_API unsigned DLL_CALLCONV FreeImage_GetHeight(FIBITMAP *dib);
  attach_function('FreeImage_GetHeight', [:pointer], :uint)

  #DLL_API unsigned DLL_CALLCONV FreeImage_GetWidth(FIBITMAP *dib);
  attach_function('FreeImage_GetWidth', [:pointer], :uint)
  
  #DLL_API unsigned DLL_CALLCONV FreeImage_GetBPP(FIBITMAP *dib);
  attach_function('FreeImage_GetBPP', [:pointer], :ulong)

  #DLL_API unsigned DLL_CALLCONV FreeImage_GetLine(FIBITMAP *dib);
  attach_function('FreeImage_GetLine', [:pointer], :ulong)

  #DLL_API unsigned DLL_CALLCONV FreeImage_GetPitch(FIBITMAP *dib);
  attach_function('FreeImage_GetPitch', [:pointer], :ulong)

  #DLL_API unsigned DLL_CALLCONV FreeImage_GetDIBSize(FIBITMAP *dib);
  attach_function('FreeImage_GetDIBSize', [:pointer], :ulong)

  #DLL_API unsigned DLL_CALLCONV FreeImage_GetDotsPerMeterX(FIBITMAP *dib);
  attach_function('FreeImage_GetDotsPerMeterX', [:pointer], :ulong)

  #DLL_API unsigned DLL_CALLCONV FreeImage_GetDotsPerMeterY(FIBITMAP *dib);
  attach_function('FreeImage_GetDotsPerMeterY', [:pointer], :ulong)

  #DLL_API void DLL_CALLCONV FreeImage_SetDotsPerMeterX(FIBITMAP *dib, unsigned res);
  attach_function('FreeImage_SetDotsPerMeterX', [:pointer, :ulong], :void)

  #DLL_API void DLL_CALLCONV FreeImage_SetDotsPerMeterY(FIBITMAP *dib, unsigned res);
  attach_function('FreeImage_SetDotsPerMeterY', [:pointer, :ulong], :void)

  #DLL_API FREE_IMAGE_COLOR_TYPE DLL_CALLCONV FreeImage_GetColorType(FIBITMAP *dib);
  attach_function('FreeImage_GetColorType', [:pointer], :color_type)

  #DLL_API unsigned DLL_CALLCONV FreeImage_GetBlueMask(FIBITMAP *dib);
  attach_function('FreeImage_GetBlueMask', [:pointer], :ulong)

  #DLL_API unsigned DLL_CALLCONV FreeImage_GetRedMask(FIBITMAP *dib);
  attach_function('FreeImage_GetRedMask', [:pointer], :ulong)

  #DLL_API unsigned DLL_CALLCONV FreeImage_GetGreenMask(FIBITMAP *dib);
  attach_function('FreeImage_GetGreenMask', [:pointer], :ulong)

  #DLL_API BITMAPINFOHEADER DLL_CALLCONV FreeImage_GetInfoHeader(FIBITMAP *dib);
  attach_function('FreeImage_GetInfoHeader', [:pointer], FreeImage::InfoHeader)

  #DLL_API BOOL DLL_CALLCONV FreeImage_hasRGBMasks(FIBITMAP *dib);
  attach_function('FreeImage_HasRGBMasks', [:pointer], FreeImage::Boolean)

  #DLL_API unsigned DLL_CALLCONV FreeImage_GetTransparencyCount(FIBITMAP *dib);
  attach_function('FreeImage_GetTransparencyCount', [:pointer], :ulong)

  #DLL_API void DLL_CALLCONV FreeImage_SetTransparent(FIBITMAP *dib, BOOL enabled);
  attach_function('FreeImage_SetTransparent', [:pointer, FreeImage::Boolean], :void)

  #DLL_API BOOL DLL_CALLCONV FreeImage_IsTransparent(FIBITMAP *dib);
  attach_function('FreeImage_IsTransparent', [:pointer], FreeImage::Boolean)

  #DLL_API void DLL_CALLCONV FreeImage_SetTransparentIndex(FIBITMAP *dib, int index);
  attach_function('FreeImage_SetTransparentIndex', [:pointer, :int], :void)

  #DLL_API int DLL_CALLCONV FreeImage_GetTransparentIndex(FIBITMAP *dib);
  attach_function('FreeImage_GetTransparentIndex', [:pointer], :int)

  #DLL_API BOOL DLL_CALLCONV FreeImage_HasBackgroundColor(FIBITMAP *dib);
  attach_function('FreeImage_HasBackgroundColor', [:pointer], FreeImage::Boolean)

  #DLL_API BOOL DLL_CALLCONV FreeImage_GetBackgroundColor(FIBITMAP *dib, RGBQUAD *bkcolor);
  attach_function('FreeImage_GetBackgroundColor', [:pointer, :pointer], FreeImage::Boolean)

  # DLL_API BOOL DLL_CALLCONV FreeImage_SetBackgroundColor(FIBITMAP *dib, RGBQUAD *bkcolor);
  attach_function('FreeImage_SetBackgroundColor', [:pointer, :pointer], FreeImage::Boolean)
  
  # Once a bitmap is loaded into memory, you can use the following methods to
  # retrieve information about is type, dimensions, colors, etc.
  module Information

    # Returns the background color of a bitmap. For 8-bit images, the color index
    # in the palette is returned in the rgbReserved member of the bkcolor parameter.
    def background_color
      ptr = FFI::MemoryPointer.new(:pointer)
      FreeImage.FreeImage_GetBackgroundColor(self, ptr)
      FreeImage.check_last_error
      RGBQuad.new(ptr)
    end

    # Set the  background color of a bitmap. The color should be an instance
    # of RGBQuad.
    #
    # When saving an image to PNG, this background
    # color is transparently saved to the PNG file. When the bkcolor parameter is nil,
    # the background color is removed from the image.
    def background_color=(value)
      result = FreeImage.FreeImage_GetBackgroundColor(self, value)
      FreeImage.check_last_error
      if !result
        raise(RuntimeError, "Could not save background color")
      end
    end

    # Returns the size of one pixel in the bitmap in bits. For example if each
    # pixel takes 32-bits of space in the bitmap, this function returns 32.
    # Possible bit depths are 1, 4, 8, 16, 24, 32 for standard bitmaps and
    # 16-, 32-, 48-, 64-, 96- and 128-bit for non standard bitmaps
    def bits_per_pixel
      result = FreeImage.FreeImage_GetBPP(self)
      FreeImage.check_last_error
      result
    end
    alias :bpp :bits_per_pixel
    
    # Returns a bit pattern describing the blue color component of a pixel in a bitmap.
    def blue_mask
      result = FreeImage.FreeImage_GetBlueMask(self)
      FreeImage.check_last_error
      result
    end

    def color_type
      result = FreeImage.FreeImage_GetColorType(self)
      FreeImage.check_last_error
      result
    end

    # Returns the size of the DIB-element of a bitmap in memory, which is the
    # header size + palette size + data bits.  Note that this is not the real
    # size of a bitmap, just the size of its DIB-element.
    def dib_size
      result = FreeImage.FreeImage_GetDIBSize(self)
      FreeImage.check_last_error
      result
    end

    # Returns the horizontal resolution, in pixels-per-meter,
    # of the target device for the bitmap.
    def dots_per_meter_x
      result = FreeImage.FreeImage_GetDotsPerMeterX(self)
      FreeImage.check_last_error
      result
    end

    # Sets the horizontal resolution, in pixels-per-meter,
    # of the target device for the bitmap.
    def dots_per_meter_x=(value)
      result = FreeImage.FreeImage_SetDotsPerMeterX(self, value)
      FreeImage.check_last_error
      result
    end

    # Returns the vertical resolution, in pixels-per-meter,
    # of the target device for the bitmap.
    def dots_per_meter_y
      result = FreeImage.FreeImage_GetDotsPerMeterY(self)
      FreeImage.check_last_error
      result
    end

    # Sets the vertical resolution, in pixels-per-meter,
    # of the target device for the bitmap.
    def dots_per_meter_y=(value)
      result = FreeImage.FreeImage_SetDotsPerMeterY(self, value)
      FreeImage.check_last_error
      result
    end

    # Returns a bit pattern describing the green color component of a pixel in a bitmap.
    def green_mask
      result = FreeImage.FreeImage_GetGreenMask(self)
      FreeImage.check_last_error
      result
    end

    # Returns true when the image has a file background color, false otherwise
    def has_background_color
      result = FreeImage.FreeImage_HasBackgroundColor(self)
      FreeImage.check_last_error
      result
    end

    # Returns true if the bitmap contains pixel data, otherwise false.  Bitmaps
    # can be loaded using the FIF_LOAD_NOPIXELS load flag whic tells the decoder
    # to read header data and available metadata and skip pixel data decoding.
    # This reduces memory usage and load speed.
    def has_pixels
      result = FreeImage.FreeImage_HasPixels(self)
      FreeImage.check_last_error
      result
    end

    def has_rgb_masks
      result = FreeImage.FreeImage_HasRGBMasks(self)
      FreeImage.check_last_error
      result
    end    

    # Returns the height of the bitmap in pixel units
    def height
      result = FreeImage.FreeImage_GetHeight(self)
      FreeImage.check_last_error
      result
    end

    # Returns the {image type}[rdoc-ref:FreeImage.image_types] of a bitmap.
    def image_type
      result = FreeImage.FreeImage_GetImageType(self)
      FreeImage.check_last_error
      result
    end

    def info_header
      result = FreeImage::InfoHeader.new(FreeImage.FreeImage_GetInfoHeader(self))
      FreeImage.check_last_error
      result
    end

    # Returns the width of the bitmap in bytes.  See also FreeImage::Information.pitch.
    # There has been some criticism on the name of this function. Some people expect it to
    # return a scanline in the pixel data, while it actually returns the width of the bitmap in
    # bytes. As far as I know the term Line is common terminology for the width of a bitmap
    # in bytes. It is at least used by Microsoft DirectX.
    def line
      result = FreeImage.FreeImage_GetLine(self)
      FreeImage.check_last_error
      result
    end

    # Returns a bitmap's palette. If the bitmap doesn’t have a palette (i.e. when the
    # pixel bit depth is greater than 8), this return nil.
    def palette
      @palette ||= Palette.new(self)
    end

    # Returns the width of the bitmap in bytes, rounded to the next 32-bit boundary,
    # also known as pitch or stride or scan width.
    # In FreeImage each scanline starts at a 32-bit boundary for performance reasons.
    # This accessor is essential when using low level {pixel manipulation}[rdoc-ref:FreeImage::Pixels]
    # functions.
    def pitch
      result = FreeImage.FreeImage_GetPitch(self)
      FreeImage.check_last_error
      result
    end

    # Returns a bit pattern describing the red color component of a pixel in a bitmap.
    def red_mask
      result = FreeImage.FreeImage_GetRedMask(self)
      FreeImage.check_last_error
      result
    end
    
    # Returns the number of transparent colors in a palletized bitmap,
    # otherwise returns 0.
    def transparency_count
      result = FreeImage.FreeImage_GetTransparencyCount(self)
      FreeImage.check_last_error
      result
    end

    # Returns true if the transparency table is enabled (1-, 4- or 8-bit images) or
    # when the input dib contains alpha values (32-bit images, RGBA16 or RGBAF images).
    # Returns false otherwise.
    def transparent
      result = FreeImage.FreeImage_IsTransparent(self)
      FreeImage.check_last_error
      result
    end

    # Tells FreeImage if it should make use of the transparency table or the alpha
    # channel that may accompany a bitmap. When calling this function with a
    # bitmap whose bitdepth is different from 1-, 4-, 8- or 32-bit, transparency
    # is disabled whatever the value of the Boolean parameter.
    def transparent=(value)
      result = FreeImage.FreeImage_SetTransparent(self, value)
      FreeImage.check_last_error
      result
    end

    # Returns the palette entry used as transparent color for the image specified.
    # Works for palletised images only and returns -1 for high color images or
    # if the image has no color set to be transparent.
    # Although it is possible for palletised images to have more than one transparent
    # color, this function always returns the index of the first palette entry,
    # set to be transparent.
    def transparent_index
      result = FreeImage.FreeImage_GetTransparentIndex(self)
      FreeImage.check_last_error
      result
    end

    # Sets the index of the palette entry to be used as transparent color for
    # the image specified. This works on palletised images only and does nothing
    # for high color images.
    #
    # Although it is possible for palletised images to have more than one transparent
    # color, this method sets the palette entry specified as the single transparent
    # color for the image. All other colors will be set to be non-transparent by this method.
    #
    # As with FreeImage::Bitmap.transparency_table=, this method also sets the
    # image's transparency property to true for palletised images.
    def transparent_index=(value)
      result = FreeImage.FreeImage_SetTransparentIndex(self, value)
      FreeImage.check_last_error
      result
    end

#  #DLL_API BOOL DLL_CALLCONV FreeImage_HasBackgroundColor(FIBITMAP *dib);
#  attach_function('FreeImage_HasBackgroundColor', [:pointer], FreeImage::Boolean)
#

    # Returns the width of the bitmap in pixel units
    def width
      result = FreeImage.FreeImage_GetWidth(self)
      FreeImage.check_last_error
      result
    end
  end
end
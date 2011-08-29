# encoding: UTF-8
module FreeImage
  #DLL_API unsigned DLL_CALLCONV FreeImage_GetColorsUsed(FIBITMAP *dib);
  attach_function('FreeImage_GetColorsUsed', [:pointer], :ulong)

  #DLL_API RGBQUAD *DLL_CALLCONV FreeImage_GetPalette(FIBITMAP *dib);
  attach_function('FreeImage_GetPalette', [:pointer], :pointer)

  # Represents a bitmaps palette. If the bitmap doesn’t have a palette (i.e. when
  # its pixel bit depth is greater than 8), this function returns nil.
  class Palette
    include Enumerable
    
    def initialize(bitmap)
      # Keep reference to bitmap so its not gc'ed
      @bitmap = bitmap
    end

    # Returns the palette-size for palletised bitmaps, and 0 for high-colour bitmaps.
    def size
      result = FreeImage.FreeImage_GetColorsUsed(@bitmap)
      FreeImage.check_last_error
      result
    end
    alias :colors_used :size

    # Returns the index color as an instance of FreeImage::RGBQuad
    def [](index)
      unless (0..self.size).include?(index)
        raise(RangeError, "Value is out of range 0..#{self.size}. Value: #{index}")
      end

      ptr = FreeImage.FreeImage_GetPalette(@bitmap)
      FreeImage.check_last_error
      RGBQuad.new(ptr[index])
    end

    def each
      size.times do |i|
        yield (self[i])
      end
    end
  end
end
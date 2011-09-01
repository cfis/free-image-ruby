module FreeImage
  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Copy(FIBITMAP *dib, int left, int top, int right, int bottom);
  attach_function('FreeImage_Copy', [:pointer, :int, :int, :int, :int], :pointer)

  #DLL_API BOOL DLL_CALLCONV FreeImage_Paste(FIBITMAP *dst, FIBITMAP *src, int left, int top, int alpha);
  attach_function('FreeImage_Paste', [:pointer, :pointer, :int, :int, :int], FreeImage::Boolean)

  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Composite(FIBITMAP *fg, BOOL useFileBkg FI_DEFAULT(FALSE), RGBQUAD *appBkColor FI_DEFAULT(NULL), FIBITMAP *bg FI_DEFAULT(NULL));
  attach_function('FreeImage_Composite', [:pointer, FreeImage::Boolean, FreeImage::RGBQuad, :pointer], :pointer)

  #DLL_API BOOL DLL_CALLCONV FreeImage_PreMultiplyWithAlpha(FIBITMAP *dib);
  #attach_function('FreeImage_PreMultiplyWithAlpha', [:pointer, :int, :int, :int, :int], FreeImage::Boolean)

  # DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Rescale(FIBITMAP *dib, int dst_width, int dst_height, FREE_IMAGE_FILTER filter);
  attach_function('FreeImage_Rescale', [:pointer, :int, :int, :filter], :pointer)

  # DLL_API FIBITMAP *DLL_CALLCONV FreeImage_MakeThumbnail(FIBITMAP *dib, int max_pixel_size, BOOL convert FI_DEFAULT(TRUE));
  attach_function('FreeImage_MakeThumbnail', [:pointer, :int, FreeImage::Boolean], :pointer)

  #DLL_API BOOL DLL_CALLCONV FreeImage_FillBackground(FIBITMAP *dib, const void *color, int options FI_DEFAULT(0));
  attach_function('FreeImage_FillBackground', [:pointer, :pointer, :int], FreeImage::Boolean)

  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_EnlargeCanvas(FIBITMAP *src, int left, int top, int right, int bottom, const void *color, int options FI_DEFAULT(0));
  attach_function('FreeImage_EnlargeCanvas', [:pointer, :int, :int, :int, :int, :pointer, :int], :pointer)

  # Background Filling Options
 
  # RGBQUAD color is a RGB color (contains no valid alpha channel)
  COLOR_IS_RGB_COLOR = 0x00	

  # RGBQUAD color is a RGBA color (contains a valid alpha channel)
  COLOR_IS_RGBA_COLOR = 0x01	

  # For palettized images: lookup equal RGB color from palette
  COLOR_FIND_EQUAL_COLOR = 0x02	

  # The color's rgbReserved member (alpha) contains the palette index to be used
  COLOR_ALPHA_IS_INDEX = 0x04	

  # No color lookup is performed
  COLOR_PALETTE_SEARCH_MASK = (COLOR_FIND_EQUAL_COLOR | COLOR_ALPHA_IS_INDEX)	

  # The \Modify module provides methods that can copy, paste, composite,
  # and enlarge images.  It also allows the creation of thumbnails and
  # filling background colors.
  #
  module Modify
    # :call-seq:
    #   image.composite(background_bitmap) -> bitmap
    #   image.composite(background_bitmap) {|img| block} -> bitmap
    #
    # Composites a transparent foreground image against a background image.
    # The equation for computing a composited sample value is:
    #
    #  output = alpha * foreground + (1-alpha) * background
    #
    # Where alpha and the input and output sample values are expressed as fractions
    # in the range 0 to 1. For color images, the computation is done separately
    # for R, G, and B samples.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def composite(background_bitmap, &block)
      ptr = FreeImage.FreeImage_Composite(self, false, nil, background_bitmap)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # :call-seq:
    #   image.composite_with_color(background_color) -> bitmap
    #   image.composite_with_color(background_color) {|img| block} -> bitmap
    #
    # Composites a transparent foreground image against a background color.
    # The equation for computing a composited sample value is:
    #
    #  output = alpha * foreground + (1-alpha) * background
    #
    # Where alpha and the input and output sample values are expressed as fractions
    # in the range 0 to 1. For color images, the computation is done separately
    # for R, G, and B samples.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def composite_with_color(background_color, &block)
      ptr = FreeImage.FreeImage_Composite(self, false, background_color, nil)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # :call-seq:
    #   image.copy(left, top, right, bottom) -> bitmap
    #   image.copy(left, top, right, bottom) {|img| block} -> bitmap
    #
    # Copy a subpart of the current image. The rectangle defined by the
    # left, top, right, bottom parameters is first normalized such that the
    # value of the left coordinate is less than the right and the top is less
    # than the bottom. Then, the returned bitmap is defined by a width equal to
    # (right - left) and a height equal to (bottom - top).
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    # 
    # The function returns the subimage if successful and othewise it returns nil.
    #
    def copy(left, top, right, bottom, &block)
      ptr = FreeImage.FreeImage_Copy(self, left, top, right, bottom)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # :call-seq:
    #   image.enlarge_canvas(left, top, right, bottom, color, options = 0) -> bitmap
    #   image.enlarge_canvas(left, top, right, bottom, color, options = 0) {|img| block} -> bitmap
    #
    # Enlarges or shrinks an image selectively per side and fills newly added areas with the
    # specified background color.  The common use case is to add borders to an image.
    #
    # To add a border to any of the image's sides, a positive integer value must be passed in
    # any of the parameters left, top, right or bottom.  This value represents the border's
    # width in pixels. Newly created parts of the image (the border areas)
    # are filled with the specified color.
    #
    # Specifying a negative integer value for a certain side, will shrink or crop the image on
    # this side. Consequently, specifying zero for a certain side will not
    # change the image's extension on that side.
    #
    # For palletized images, the palette of the current image src is transparently
    # copied to the newly created enlarged or shrunken image, so any color look-ups
    # are performed on this palette.
    #
    # == Parameters:
    #
    # left:: The number of pixels the image should be enlarged on its left side. Negative
    #        values shrink the image on its left side.
    # top:: The number of pixels the image should be enlarged on its top side. Negative
    #       values shrink the image on its top side.
    # right:: The number of pixels the image should be enlarged on its right side. Negative
    #         values shrink the image on its right side.
    # bottom:: The number of pixels, the image should be enlarged on its bottom side.
    #          Negative values shrink the image on its bottom side.
    # color:: The color value to be used for filling the image.  See #fill_background for
    #         more details.
    # options:: Used to control color search process for palletized images. See
    #           #fill_background for more details.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    # 
    # Returns a new image on success or nil.
    #
    def enlarge_canvas(left, top, right, bottom, color, options = 0, &block)
      ptr = FreeImage.FreeImage_EnlargeCanvas(self, left, top, right, bottom, color, options)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # Sets all pixels of an image to the specified color.
    #
    # == Parameters:
    #
    # color:: The color value to be used for filling the image.
    #
    #          The type of the color parameter depends on the
    #          {image type}[rdoc-ref:FreeImage.image_types]
    #
    #          bitmap::  RGBQuad
    #          rgb16::   RGB16
    #          rgba16::  RGBA16
    #          rgbf::    RGBF
    #          rgbaf::   RGBFA
    #          complex:: Complex
    #          others::  A value of the specific type (double, int, etc.).
    #
    # options:: Used to control color search process for palletized images.
    #            Allowed values are defined as constants on the FreeImage
    #            module and include:
    #            COLOR_IS_RGB_COLOR = 0x00
    #            COLOR_IS_RGBA_COLOR = 0x01
    #            COLOR_FIND_EQUAL_COLOR = 0x02
    #            COLOR_ALPHA_IS_INDEX = 0x04
    #            COLOR_PALETTE_SEARCH_MASK = (FI_COLOR_FIND_EQUAL_COLOR | FI_COLOR_ALPHA_IS_INDEX)
    #
    # Returns true on success, false on failure.
    #
    def fill_background!(color, options = 0)
      result = FreeImage.FreeImage_FillBackground(self, color, options)
      FreeImage.check_last_error
      result
    end

    # :call-seq:
    #   bitmap.make_thumbnail(max_pixel_size, convert = true) -> bitmap
    #   bitmap.make_thumbnail(max_pixel_size, convert = true) {|img| block} -> bitmap
    #
    # Creates a thumbnail image that fits inside a square of size max_pixel_size,
    # keeping the original aspect ratio intact.  Downsampling is done using a bilinear
    # {filter}[rdoc-ref:FreeImage::Sampling.rescale].
    #
    # == Parameters:
    #
    # max_pixel_size:: The maximum width/height of the returned image
    # convert:: When set to true, High Dynamic Range images (FIT_UINT16,
    #           FIT_RGB16, FIT_RGBA16, FIT_FLOAT) are transparently converted
    #           to standard images (i.e. 8-, 24 or 32-bit images).  The
    #           default value is true.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def make_thumbnail(max_pixel_size, convert = true, &block)
      ptr = FreeImage.FreeImage_MakeThumbnail(self, max_pixel_size, convert)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # Combines or blends a subpart of another image with the current image.
    #
    # == Parameters:
    #
    # other:: Source subimage
    # left::  Specifies the left position of the sub image.
    # top::   Specifies the top position of the sub image.
    # alpha:: Alpha blend factor. If alpha is 0..255, the other images is
    #          alpha blended withe current image. If alpha > 255, then
    #          the other image is combined to the current image.
    #
    # The function returns true if successful, otherwise false.
    #
    def paste!(other, left, top, alpha)
      result = FreeImage.FreeImage_Paste(self, other, left, top, alpha)
      FreeImage.check_last_error
      result
    end

    # :call-seq:
    #   bitmap.rescale(width, height, filter) -> bitmap
    #   bitmap.rescale(width, height, filter) {|img| block} -> bitmap -> bitmap
    #
    # Resamples an image to the desired width and height. Resampling changes the
    # pixel dimensions (and therefore display size) of an image.
    # When you downsample (or decrease the number of pixels), information is deleted from
    # the image. When you upsample (or increase the number of pixels), new pixels are
    # added based on color values of existing pixels. You can specify an interpolation
    # filter to determine how pixels are added or deleted using the filter parameter.
    #
    # Returns the newly resample image or nil if the image cannot be resampled.
    #
    # == Parameters:
    #
    # width:: The width of the new image
    # height:: The height of the new image
    # filter:: The filter to use when rescaling
    #
    # Filter options include:
    #
    # :box:: The simplest and fastest of the scaling algorithms.  The technique achieves
    #        magnification by pixel replication, and minification by sparse point sampling.
    #        For large-scale changes, box interpolation produces images with a
    #        blocky appearance. In addition, shift errors of up to one-half pixel are
    #        possible. These problems make this technique inappropriate when
    #        sub-pixel accuracy is required.
    #
    # :bicubic:: An advanced parameterized scaling filter. It uses a cubic
    #            to produce very smooth output while maintaining dynamic range
    #            and sharpness. Bicubic scaling takes approximately twice the
    #            processing time as Bilinear. This filter can be used for any
    #            scaling application, especially when scaling factors are 2X
    #            or greater.
    #
    # :bilinear:: The second-fastest scaling function. It employs linear interpolation
    #             to determine the output image. Bilinear scaling provides reasonably
    #             good results at moderate cost for most applications where scale
    #             factors are relatively small (4X or less).
    #
    # :bspline:: Produces the smoothest output, but tends to smooth over fine details.
    #            This function requires the same processing time as :bicubic filter.
    #            It is recommended for applications where the smoothest output is required.
    #
    # :catmullrom:: The Catmull-Rom filter is generally accepted as the best cubic interpolant filter.
    #
    # :lanczos3:: A sinc based filter. It is the most theoretically correct filter
    #             that produces the best output for photographic images that do not have
    #             sharp transitions in them. However, Lanczos will produce ripple artefacts
    #             especially for block text, due to aliasing.  It requires three times the
    #             processing time of Bilinear. Lanczos is not recommended except in very
    #             rare applications using band-limited photographic images with
    #             no sharp edges.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def rescale(width, height, filter = :bilinear, &block)
      ptr = FreeImage.FreeImage_Rescale(self, width, height, filter)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end
  end
end
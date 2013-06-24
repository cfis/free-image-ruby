module FreeImage
  # DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Rotate(FIBITMAP *dib, double angle, const void *bkcolor FI_DEFAULT(NULL));
  attach_function('FreeImage_Rotate', [:pointer, :double, :pointer], :pointer)

  # DLL_API FIBITMAP *DLL_CALLCONV FreeImage_RotateEx(FIBITMAP *dib, double angle, double x_shift, double y_shift, double x_origin, double y_origin, BOOL use_mask);
  attach_function('FreeImage_RotateEx', [:pointer, :double, :double, :double, :double, :double, FreeImage::Boolean], :pointer)

  # DLL_API BOOL DLL_CALLCONV FreeImage_FlipHorizontal(FIBITMAP *dib);
  attach_function('FreeImage_FlipHorizontal', [:pointer], FreeImage::Boolean)

  # DLL_API BOOL DLL_CALLCONV FreeImage_FlipVertical(FIBITMAP *dib);
  attach_function('FreeImage_FlipVertical', [:pointer], FreeImage::Boolean)

  module Transforms
    # call-seq:
    #   bitmap.rotate(angle, bk_color) -> bitmap
    #   bitmap.rotate(angle, bk_color) -> {|img| block} -> bitmap
    #
    # Rotates an image around the center of the image area by means of 3 shears.
    # The rotated image retains the same size and aspect ratio of source image
    # (the resulting image size is usually bigger), so that this function should
    # be used when rotating an image by 90°, 180° or 270°.
    #
    # When the angle value isn’t an integer multiple of 90°, the background is
    # filled with the supplied bkcolor parameter.  When bkcolor is nil, the
    # default value, the background is filled with a black.
    #
    # == Parameters
    #
    #  angle::    Specifies the angle of rotation in degrees
    #  bk_color:: The color used to fill the background.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def rotate(angle, bk_color = nil, &block)
      ptr = FreeImage.FreeImage_Rotate(self, angle, bk_color)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # call-seq:
    #   bitmap.rotate_ex(aangle, x_shift, y_shift, x_origin, y_origin, use_mask = false) -> bitmap
    #   bitmap.rotate_ex(aangle, x_shift, y_shift, x_origin, y_origin, use_mask = false) {|img| block} -> bitmap
    #
    # Rotates an image using a 3rd order (cubic) B-Spline. The rotated image will have
    # the same width and height as the source image, so that this function is better
    # suited for computer vision and robotics.
    #
    # == Parameters:
    #
    #  angle::    Specifies the angle of rotation in degrees
    #  x_shift::  Specifies horizonal image translation
    #  y_shift::  Specifies vertical image translation
    #  x_origin:: Specifies the x coordinate of the center of rotation
    #  y_origin:: Specifies the y coordinate of the center of rotation
    #  use_mask:: When true, irrelevant parts of the image are set to black,
    #             otherwise, a mirroring technique is used to fill irrelevant pixels.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def rotate_ex(angle, x_shift, y_shift, x_origin, y_origin, use_mask = false, &block)
      ptr = FreeImage.FreeImage_RotateEx(self, angle, x_shift, y_shift, x_origin, y_origin, use_mask)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # call-seq:
    #   bitmap.flip_horizontal -> boolean
    #
    # Flip the input image horizontally along the vertical axis.
    #
    def flip_horizontal!
      result = FreeImage.FreeImage_FlipHorizontal(self)
      FreeImage.check_last_error
      result
    end

    # call-seq:
    #   bitmap.flip_vertical -> boolean
    #
    # Flip the input image vertically along the horizontal axis.
    #
    def flip_vertical!
      result = FreeImage.FreeImage_FlipVertical(self)
      FreeImage.check_last_error
      result
    end
  end
end
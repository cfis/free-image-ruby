module FreeImage
  #DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Allocate(int width, int height, int bpp, unsigned red_mask FI_DEFAULT(0), unsigned green_mask FI_DEFAULT(0), unsigned blue_mask FI_DEFAULT(0));
  attach_function('FreeImage_Allocate', [:int, :int, :int, :uint, :uint, :uint], :pointer)

  # DLL_API FIBITMAP * DLL_CALLCONV FreeImage_Clone(FIBITMAP *dib);
  attach_function('FreeImage_Clone', [:pointer], :pointer)

  # DLL_API void DLL_CALLCONV FreeImage_Unload(FIBITMAP *dib);
  attach_function('FreeImage_Unload', [:pointer], :void)

  # == Summary
  #
  # Represents an image that has been loaded into memory.  Once the image is loaded,
  # you can get
  # information[rdoc-ref:FreeImage::Information] about it,
  # convert[rdoc-ref:FreeImage::Conversions] it,
  # modify[rdoc-ref:FreeImage::Modify] it.
  # transform[rdoc-ref:FreeImage::Information] it,
  #
  # == Usage
  #
  #   # Open an image form a file
  #   image = FreeImage::BitmapFile.open('test/fixtures/lena.png')
  #
  #   # Get information about it
  #   bg = image.background_color
  #
  #   # Convert it
  #   image = image.convert_to_greyscale
  #
  #   # Modify it
  #   image = image.convert_to_greyscale
  #
  #   # Transform it
  #   image = image.rotate(90)
  #
  class Bitmap < FFI::AutoPointer
    include Conversions
    include ICC
    include Information
    include Modify
    include Pixels
    include Transforms

    ## The source of the image.  May be a File, in Memory string, IO stream or nil.
    attr_reader :source

    # Creates a new image with the specified width, height and bits per pixel.
    #
    # == Parameters
    # width:: The width of the new image
    # height:: The height of the new image
    # bits_per_pixel:: The size in bits of a pixel
    # red_mask:: The bit-layout of the red color component in a bitmap
    # green_mask:P: The bit-layout of the green color component in a bitmap
    # blue_mask:: The bit-layout of the blue color component in a bitmap
    #
    # The last three parameter are used to tell FreeImage the bit-layout of
    # the color components in the bitmap, e.g. where in a pixel the red,
    # green and blue components are stored.
    #
    # To give you an idea about how to interpret the color masks:
    # when red_mask is 0xFF000000 this means that the last 8 bits in
    # one pixel are used for the color red. When green_mask is 0x000000FF, it
    # means that the first 8 bits in a pixel are used for the color green.
    #
    # The new image is initially filled completely with zeroes. Zero in a image
    # is usually interpreted as black. This means that if your bitmap is palletized
    # it will contain a completely black palette. You can access, and hence populate
    # the palette via #palette.
    #
    # For 8-bit images, a default greyscale palette will also be created.
    #
    def self.create(width, height, bits_per_pixel, red_mask = 0, green_mask = 0, blue_mask = 0)
      ptr = FreeImage.FreeImage_Allocate(width, height, bits_per_pixel, red_mask, green_mask, blue_mask)
      FreeImage.check_last_error
      new(ptr)
    end

    # Opens a new image from the specified source.
    #
    # == Parameters
    # source:: The source of the image
    #
    # The source parameter can be a File, Memory or IO stream.  It can
    # also be a string which is interpreted as a fully qualified file path.
    def self.open(source)
      bitmap = figure_source(source).open
      if block_given?
        begin
          yield bitmap
        ensure
          bitmap.free
        end
      else
        bitmap
      end
    end

    def self.new(ptr, source = nil)
      # Ptr must be set
      if ptr.null?
        error = Error.new(:unknown, "Cannot create a bitmap from a null pointer")
        raise(error)
      end

      bitmap = super(ptr, source)

      if block_given?
        begin
          yield bitmap
        ensure
          bitmap.free
        end
      else
        bitmap
      end
    end

    # Closes an image and releases its associated memory.  This
    # is called by the ruby Garbage collector and should not
    # be called directly.  If you would like to free an image
    # after using it, please use Bitmap#free.
    def self.release(ptr) #:nodoc:
      FreeImage.FreeImage_Unload(ptr)
    end

    # Creates a new image from a c-pointer an image source.  Generally you
    # do not want to use this method.  Instead, use Bitmap.open.
    def initialize(ptr, source = nil)
      @source = source
      super(ptr)
    end

    # :call-seq:
    #   image.clone -> bitmap
    #   image.clone {|img| block} -> bitmap
    # 
    # Creates an exact copy of the current image.
    #
    # If an optional block is provided, it will be passed the new image as an argument.  The
    # image will be automatically closed when the block completes.
    #
    def clone(&block)
      ptr = FreeImage.FreeImage_Clone(self)
      FreeImage.check_last_error
      self.class.new(ptr, &block)
    end

    # Save the image to the specified source.
    #
    # == Parameters
    # dst::     The destination where the image will be saved.
    # format::  The format[rdoc-ref:FreeImage.formats] to save the image to.
    # flags::   Format specific flags that control how a bitmap is saved.  These flags are defined
    #           as constants on the AbstractSource[rdoc-ref:FreeImage::AbstractSource::Encoder] class.
    #           Flags can be combined using Ruby's bitwise or operator (|)
    #
    def save(source, format, flags = 0)
      self.class.figure_source(source).save(self, format, flags)
    end

    private

    def self.figure_source(source)
      case source
      when AbstractSource
        source
      when ::IO
        IO.new(source)
      when String
        File.new(source)
      else
        raise(ArgumentError, "Unknown source type: #{source.class.name}")
      end
    end
  end
end
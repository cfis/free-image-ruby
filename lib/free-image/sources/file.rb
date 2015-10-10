module FreeImage
  # DLL_API FREE_IMAGE_FORMAT DLL_CALLCONV FreeImage_GetFileType(const char *filename, int size FI_DEFAULT(0));
  attach_function('FreeImage_GetFileType', [:string, :int], :format)

  # DLL_API FREE_IMAGE_FORMAT DLL_CALLCONV FreeImage_GetFIFFromFilename(const char *filename);
  attach_function('FreeImage_GetFIFFromFilename', [:string], :format)

  # DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Load(FREE_IMAGE_FORMAT fif, const char *filename, int flags FI_DEFAULT(0));
  attach_function('FreeImage_Load', [:format, :string, :int], :pointer)

  # DLL_API BOOL DLL_CALLCONV FreeImage_FIFSupportsReading(FREE_IMAGE_FORMAT fif);
  attach_function('FreeImage_FIFSupportsReading', [:format], FreeImage::Boolean)

  # DLL_API BOOL DLL_CALLCONV FreeImage_Save(FREE_IMAGE_FORMAT fif, FIBITMAP *dib, const char *filename, int flags FI_DEFAULT(0));
  attach_function('FreeImage_Save', [:format, :pointer, :string, :int], FreeImage::Boolean)

  # == Summary
  #
  # Supports loading and saving images to a file.
  #
  # == Usage
  #
  #   # Open a file
  #   src = FreeImage::File.new('test/fixtures/lena.png')
  #   image = src.open
  #   
  #   # Save a file
  #   dest = FreeImage::File.new('test/fixtures/lena_new.jpeg')
  #   image.save(dest, :jpeg)
  #
  class File < AbstractSource
    ##
    # :call-seq:
    #   file.open(format = nil, flags = 0) -> FreeImage::Bitmap
    #
    # Opens an image from a file.
    #
    # == Parameters
    # format:: By default FreeImage will automatically determine an image's format.  However,
    #           you may override this value by using this parameter to specify a
    #           particular {format}[rdoc-ref:FreeImage.formats].
    # flags:: Format specific flags that control how a bitmap is loaded.  These flags are defined
    #          as constants on the AbstractSource::Decoder module.  Flags can be combined using
    #          Ruby's bitwise or operator (|)
    #
    # == Usage
    #
    #   source = File.new('<path_to_file>')
    #   source.open(:jpeg, AbtractSource::JPEG_QUALITYSUPERB | AbtractSource::JPEG_PROGRESSIVE)
    #

    # Create a new FreeImage::File instance that can read and write image data
    # from a file.
    #
    # == Parameters
    # image_path:: The full path to a image file.
    #
    def initialize(image_path)
      @image_path = image_path
    end

    # :call-seq:
    #    file.format -> :format
    #
    # Returns the image {format}[rdoc-ref:FreeImage.formats] for a file. If the image format cannot
    # be determined then will return :unknown.
    #
    def format
      result = FreeImage.FreeImage_GetFileType(@image_path, 0)
      FreeImage.check_last_error

      if result == :unknown
        # Try to guess the file format from the file extension
        result = FreeImage.FreeImage_GetFIFFromFilename(@image_path)
        FreeImage.check_last_error
      end
      result
    end

    ##
    # :call-seq:
    #   file.save(format = nil, flags = 0) -> boolean
    #
    # Saves an image to a file.
    #
    # == Parameters
    # format:: The format[rdoc-ref:FreeImage.formats] to save the image to.
    # flags::   Format specific flags that control how a bitmap is saved.  These flags are defined
    #           as constants on the AbstractSource[rdoc-ref:FreeImage::AbstractSource::Encoder] class.
    #           Flags can be combined using Ruby's bitwise or operator (|)
    #
    # == Usage
    #
    #   image = Bimap.open('<path_to_file>')
    #   dst = File.new('<path_to_new_file>')
    #   dst.save(image, :jpeg, AbtractSource::JPEG_QUALITYSUPERB | AbtractSource::JPEG_PROGRESSIVE)
    #
    def save(bitmap, format, flags = 0)
      result = FreeImage.FreeImage_Save(format, bitmap, @image_path, flags)
      FreeImage.check_last_error
      result
    end

    private

    def load(format, flags)
      if format == :unknown
       # raise(Error, "Cannot load unknown file format")
      end
      ptr = FreeImage.FreeImage_Load(format, @image_path, flags)
      FreeImage.check_last_error
      ptr
    end
  end
end
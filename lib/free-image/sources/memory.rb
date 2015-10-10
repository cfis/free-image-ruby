module FreeImage
  typedef :pointer, :memory

  #DLL_API void DLL_CALLCONV FreeImage_CloseMemory(FIMEMORY *stream);
  attach_function('FreeImage_CloseMemory', [:memory], :void)

  #DLL_API FIMEMORY *DLL_CALLCONV FreeImage_OpenMemory(BYTE *data FI_DEFAULT(0), DWORD size_in_bytes FI_DEFAULT(0));
  attach_function('FreeImage_OpenMemory', [:pointer, :dword], :memory)

  # DLL_API FREE_IMAGE_FORMAT DLL_CALLCONV FreeImage_GetFileTypeFromMemory(FIMEMORY *stream, int size FI_DEFAULT(0));
  attach_function('FreeImage_GetFileTypeFromMemory', [:memory, :int], :format)

  # DLL_API FIBITMAP *DLL_CALLCONV FreeImage_LoadFromMemory(FREE_IMAGE_FORMAT fif, FIMEMORY *stream, int flags FI_DEFAULT(0))
  attach_function('FreeImage_LoadFromMemory', [:format, :memory, :int], :pointer)

  # DLL_API BOOL DLL_CALLCONV FreeImage_SaveToMemory(FREE_IMAGE_FORMAT fif, FIBITMAP *dib, FIMEMORY *stream, int flags FI_DEFAULT(0));
  attach_function('FreeImage_SaveToMemory', [:format, :pointer, :memory, :int], FreeImage::Boolean)

  #DLL_API unsigned DLL_CALLCONV FreeImage_ReadMemory(void *buffer, unsigned size, unsigned count, FIMEMORY *stream);
  attach_function('FreeImage_ReadMemory', [:pointer, :ulong, :ulong, :memory], :ulong)

  # DLL_API long DLL_CALLCONV FreeImage_TellMemory(FIMEMORY *stream);
  attach_function('FreeImage_TellMemory', [:memory], :long)

  #DLL_API BOOL DLL_CALLCONV FreeImage_SeekMemory(FIMEMORY *stream, long offset, int origin);
  attach_function('FreeImage_SeekMemory', [:memory, :long, :int], FreeImage::Boolean)

  #DLL_API BOOL DLL_CALLCONV FreeImage_AcquireMemory(FIMEMORY *stream, BYTE **data, DWORD *size_in_bytes);
  #DLL_API unsigned DLL_CALLCONV FreeImage_WriteMemory(const void *buffer, unsigned size, unsigned count, FIMEMORY *stream);
  #DLL_API FIMULTIBITMAP *DLL_CALLCONV FreeImage_LoadMultiBitmapFromMemory(FREE_IMAGE_FORMAT fif, FIMEMORY *stream, int flags FI_DEFAULT(0));
  #DLL_API BOOL DLL_CALLCONV FreeImage_SaveMultiBitmapToMemory(FREE_IMAGE_FORMAT fif, FIMULTIBITMAP *bitmap, FIMEMORY *stream, int flags);

  # Wrapper for a FreeImage memory stream which allows images to be read and written
  # to memory.  Memory streams are usefule for storing images as blobs in a database
  # or writing them to an to a Internet stream.
  class MemoryStream < FFI::AutoPointer
    def self.release(ptr)
      FreeImage.FreeImage_CloseMemory(ptr)
      FreeImage.check_last_error
    end

    # Create a new memory stream.
    #
    # == Parameters
    # bytes::  If specified, a binary encoded Ruby string that stores image data.  FreeImage
    #          will treat the string as read-only.  If not specified, a writable MemoryStream
    #          is created.
    def initialize(bytes = nil)
      ptr = if bytes
        buf = FFI::MemoryPointer.from_string(bytes)
        FreeImage.FreeImage_OpenMemory(buf, bytes.bytesize)
      else
        FreeImage.FreeImage_OpenMemory(nil, 0)
      end
      FreeImage.check_last_error

      super(ptr)
    end

    # Returns the size of the memory stream.
    def count
      # Store current position
      pos = FreeImage.FreeImage_TellMemory(self)
      FreeImage.check_last_error

      # Go to end of stream to get length
      FreeImage.FreeImage_SeekMemory(self, 0, ::IO::SEEK_END)
      FreeImage.check_last_error
      count = FreeImage.FreeImage_TellMemory(self)

      # Restore position
      FreeImage.FreeImage_SeekMemory(self, pos, ::IO::SEEK_SET)
      FreeImage.check_last_error

      count
    end

    # Returns the bytes of the memory stream.
    def bytes
      size = FFI::Type::CHAR.size

      # Reset memory to start
      FreeImage.FreeImage_SeekMemory(self, 0, ::IO::SEEK_SET)
      FreeImage.check_last_error

      buffer = FFI::MemoryPointer.new(FFI::Type::CHAR, size * count)
      FreeImage.check_last_error
      size = FreeImage.FreeImage_ReadMemory(buffer, size, count, self)
      buffer.null? ? nil : buffer.read_string
    end
  end

  # == Summary
  #
  # Supports loading and saving images to a Ruby string.
  #
  # == Usage
  #
  #   # Read an image from a byte string
  #   bytes = ::File.read('test/fixtures/lena.png', :encoding => Encoding::BINARY)
  #   image = FreeImage::Memory.open(bytes)
  #
  #   # Save an image to a byte string
  #   dest = FreeImage::Memory.new
  #   image.save(dest, :jpeg)
  #   dest.bytes
  #
  class Memory < AbstractSource
    ##
    # MemoryStream used to read and write data
    attr_reader :memory
    
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
    # from memory.
    #
    # == Parameters
    # bytes:: If specified, FreeImage will read image from the bytes string and treat
    #         it as readonly.  If not specified, then FreeImage will create a writable
    #         memory stream.
    #
    def initialize(bytes = nil)
      @memory = MemoryStream.new(bytes)
    end

    # call-seq:
    #    memory.format -> :format
    #
    # Returns the image format for a memory stream. If the image format cannot be determined
    # the :unknown will be returned.
    def format
      result = FreeImage.FreeImage_GetFileTypeFromMemory(@memory, 0)
      FreeImage.check_last_error
      result
    end

    ##
    # :call-seq:
    #   memory.save(format = nil, flags = 0) -> boolean
    #
    # Saves an image to memory.
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
    #   dst = FreeImage::Memory.new
    #   dst.save(image, :jpeg, AbtractSource::JPEG_QUALITYSUPERB | AbtractSource::JPEG_PROGRESSIVE)
    #   dst.bytes
    #
    def save(bitmap, format, flags = 0)
      result = FreeImage.FreeImage_SaveToMemory(format, bitmap, @memory, flags)
      FreeImage.check_last_error
      result
    end

    private

    def load(format, flags)
      ptr = FreeImage.FreeImage_LoadFromMemory(format, @memory, flags)
      FreeImage.check_last_error
      ptr
    end
  end
end
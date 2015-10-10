module FreeImage
  typedef :pointer, :handle
  
  #typedef unsigned (DLL_CALLCONV *FI_ReadProc) (void *buffer, unsigned size, unsigned count, fi_handle handle);
  callback :read_proc_callback, [:pointer, :ulong, :ulong, :handle], :ulong

  #typedef unsigned (DLL_CALLCONV *FI_WriteProc) (void *buffer, unsigned size, unsigned count, fi_handle handle);
  callback :write_proc_callback, [:pointer, :ulong, :ulong, :handle], :ulong

  #typedef int (DLL_CALLCONV *FI_SeekProc) (fi_handle handle, long offset, int origin);
  callback :seek_proc_callback, [:handle, :long, :int], :ulong

  #typedef long (DLL_CALLCONV *FI_TellProc) (fi_handle handle);
  callback :tell_proc_callback, [:handle], :long

  class IOStruct < FFI::Struct
    layout :read_proc,  :read_proc_callback,
           :write_proc, :write_proc_callback,
           :seek_proc,  :seek_proc_callback,
           :tell_proc,  :tell_proc_callback
  end

  # DLL_API FREE_IMAGE_FORMAT DLL_CALLCONV FreeImage_GetFileTypeFromHandle(FreeImageIO *io, fi_handle handle, int size FI_DEFAULT(0));
  attach_function('FreeImage_GetFileTypeFromHandle', [FreeImage::IOStruct, :handle, :int], :format)

  # DLL_API FIBITMAP *DLL_CALLCONV FreeImage_LoadFromHandle(FREE_IMAGE_FORMAT fif, FreeImageIO *io, fi_handle handle, int flags FI_DEFAULT(0));
  attach_function('FreeImage_LoadFromHandle', [:format, FreeImage::IOStruct, :handle, :int], :pointer)

  # DLL_API BOOL DLL_CALLCONV FreeImage_SaveToHandle(FREE_IMAGE_FORMAT fif, FIBITMAP *dib, FreeImageIO *io, fi_handle handle, int flags FI_DEFAULT(0));
  attach_function('FreeImage_SaveToHandle', [:format, :pointer, FreeImage::IOStruct, :handle, :int], FreeImage::Boolean)

  # == Summary
  #
  # Supports loading and saving images to a Ruby IO stream.
  #
  # == Usage
  #
  #   # Read an image from an io stream string
  #   file = ::File.open('test/fixtures/lena.png', :encoding => Encoding::BINARY)
  #   image = FreeImage::IO.open(file)
  #
  #   # Save an image to a byte string
  #   dest = FreeImage::IO.new(::File.open('test/fixtures/lena_new.png', :encoding => Encoding::BINARY))
  #   image.save(dest, :jpeg)
  #   dest.bytes
  #
  class IO < AbstractSource
    ##
    # :call-seq:
    #   io.open(format = nil, flags = 0) -> FreeImage::Bitmap
    #
    # Opens an image from a Ruby IO stream.
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
    #   source = FreeImage::IO.new(::File.open('<path_to_file>'))
    #   source.open(:jpeg, AbtractSource::JPEG_QUALITYSUPERB | AbtractSource::JPEG_PROGRESSIVE)
    #

    # Create a new FreeImage::IO instance that can read and write image data
    # from a Ruby IO stream.
    #
    # == Parameters
    # io:: A standard Ruby io stream such as a file.
    #
    def initialize(io)
      @io = io

      @handle = FFI::MemoryPointer.new(:ulong)
      @handle.put_ulong(0, self.object_id)

      @ffi_io = FreeImage::IOStruct.new
      @ffi_io[:read_proc] = method(:read)
      @ffi_io[:write_proc] = method(:write)
      @ffi_io[:seek_proc] = method(:seek)
      @ffi_io[:tell_proc] = method(:tell)
    end


    # call-seq:
    #    handle.image_type -> :format
    #
    # Returns the image format for a memory stream. If the image format cannot be determined
    # the :unknown will be returned.
    def format
      result = FreeImage.FreeImage_GetFileTypeFromHandle(@ffi_io, @handle, 0)
      FreeImage.check_last_error
      result
    rescue Errno::EINVAL => e
      :unknown
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
    #   source = FreeImage::File.new('<path_to_new_file>')
    #   source.save(image, :jpeg, AbtractSource::JPEG_QUALITYSUPERB | AbtractSource::JPEG_PROGRESSIVE)
    #
    def save(bitmap, format, flags = 0)
      result = FreeImage.FreeImage_SaveToHandle(format, bitmap, @ffi_io, @handle, flags)
      FreeImage.check_last_error
      result
    end

    private

    def load(format, flags)
      ptr = FreeImage.FreeImage_LoadFromHandle(format, @ffi_io, @handle, flags)
      FreeImage.check_last_error
      ptr
    end

    def read(buffer, size, count, handle)
      bytes = @io.read(size * count)
      return 0 unless bytes
      buffer.put_bytes(0, bytes)
      bytes.bytesize
    end

    def write(buffer, size, count, handle)
      bytes = buffer.get_bytes(0, size * count)
      @io.write(bytes)
      bytes.bytesize
    end

    def seek(handle, offset, origin)
      @io.seek(offset, origin)
    end

    def tell(handle)
      @io.tell
    end
  end
end
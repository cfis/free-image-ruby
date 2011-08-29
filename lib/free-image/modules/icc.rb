module FreeImage
  # DLL_API BOOL DLL_CALLCONV FreeImage_FIFSupportsICCProfiles(FREE_IMAGE_FORMAT fif)
  attach_function(:icc_supported, 'FreeImage_FIFSupportsICCProfiles', [:format], FreeImage::Boolean)
  module_function :icc_supported

  module ICC
    class Profile < FFI::Struct
      layout :flags, :int,
             :size,  :uint,
             :data,  :pointer
    end

    # DLL_API FIICCPROFILE *DLL_CALLCONV FreeImage_GetICCProfile(FIBITMAP *dib)
    FreeImage.attach_function('FreeImage_GetICCProfile', [:pointer], FreeImage::ICC::Profile)

    def icc_profile
      result = FreeImage.FreeImage_GetICCProfile(self)
      FreeImage.check_last_error
      result
    end

    # DLL_API FIICCPROFILE *DLL_CALLCONV FreeImage_CreateICCProfile(FIBITMAP *dib, void *data, long size);
    FreeImage.attach_function('FreeImage_CreateICCProfile', [:pointer, :pointer, :long], FreeImage::ICC::Profile)
    # DLL_API void DLL_CALLCONV FreeImage_DestroyICCProfile(FIBITMAP *dib);
    FreeImage.attach_function('FreeImage_DestroyICCProfile', [:pointer], :void)

    def icc_profile=(value)
      result = if value
        FreeImage.FreeImage_CreateICCProfile(self, value[:data], value[:size])
      else
        FreeImage.FreeImage_DestroyICCProfile(self)
      end
      FreeImage.check_last_error
      result
    end

    def icc_supported?
      FreeImage.icc_supported(self)
    end
  end
end
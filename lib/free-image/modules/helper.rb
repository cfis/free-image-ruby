module FreeImage
  #DLL_API const char *DLL_CALLCONV FreeImage_GetVersion(void);
  attach_function('FreeImage_GetVersion', [], :string)

  #DLL_API const char *DLL_CALLCONV FreeImage_GetCopyrightMessage(void);
  attach_function('FreeImage_GetCopyrightMessage', [], :string)

  #DLL_API BOOL DLL_CALLCONV FreeImage_IsLittleEndian(void);
  attach_function('FreeImage_IsLittleEndian', [], FreeImage::Boolean)

  ##
  # :call-seq:
  #   version -> string
  #
  # Returns the current version of the FreeImage library
  #
  def self.version
    FreeImage.FreeImage_GetVersion
  end
  
  ##
  # :call-seq:
  #   copyright -> string
  #
  # Returns a standard copyright message you can show in your program.
  #
  def self.copyright
    FreeImage.FreeImage_GetCopyrightMessage
  end

  ##
  # :call-seq:
  #   is_little_endian? -> boolean
  #
  # Returns TRUE if the platform running FreeImage uses the Little Endian
  # convention (Intel processors) and returns FALSE if it uses the Big Endian
  # (Motorola processors).
  #
  def self.little_endian?
    FreeImage.FreeImage_IsLittleEndian
  end
end
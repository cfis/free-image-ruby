# encoding: UTF-8

module FreeImage
  # BI_RGB
  RGB = 0
  # BI_BITFIELDS
  BITFIELDS = 3
  # Structure for BITMAPINFOHEADER
=begin
  DWORD biSize;
  LONG  biWidth; 
  LONG  biHeight; 
  WORD  biPlanes; 
  WORD  biBitCount;
  DWORD biCompression; 
  DWORD biSizeImage; 
  LONG  biXPelsPerMeter; 
  LONG  biYPelsPerMeter; 
  DWORD biClrUsed; 
  DWORD biClrImportant;
=end
  class InfoHeader < FFI::Struct
    layout :biSize,          :dword, 0,
           :biWidth,         :long,  4,
           :biHeight,        :long,  8,
           :biPlanes,        :word,  12,
           :biBitCount,      :word,  14,
           :biCompression,   :dword, 16,
           :biSizeImage,     :dword, 20,
           :biXPelsPerMeter, :long,  24,
           :biYPelsPerMeter, :long,  28,
           :biClrUsed,       :dword, 32,
           :biClrImportant,  :dword, 36

  end
end
# encoding: UTF-8

module FreeImage
  ##
  # FreeImage supports over 30 bitmap types, which are indentified via symbols.
  # Supported formats include:
  # 
  # :bmp:: Windows or OS/2 Bitmap File (*.BMP)
  # :cut:: Dr. Halo (*.CUT)
  # :dds:: DirectDraw Surface (*.DDS)
  # :exr:: ILM OpenEXR (*.EXR)
  # :faxg3:: Raw Fax format CCITT G3 (*.G3)
  # :gif:: Graphics Interchange Format (*.GIF)
  # :hdr:: High Dynamic Range (*.HDR)
  # :ico:: Windows Icon (*.ICO)
  # :iff:: Amiga IFF (*.IFF, *.LBM)
  # :jpeg:: Independent JPEG Group (*.JPG, *.JIF, *.JPEG, *.JPE)
  # :jng:: JPEG Network Graphics (*.JNG)
  # :j2k:: JPEG-2000 codestream (*.J2K, *.J2C)
  # :jp2:: JPEG-2000 File Format (*.JP2)
  # :koala:: Commodore 64 Koala format (*.KOA)
  # :lbm:: Amiga IFF (*.IFF, *.LBM)
  # :mng:: Multiple Network Graphics (*.MNG)
  # :pbm:: Portable Bitmap (ASCII) (*.PBM)
  # :pbmraw:: Portable Bitmap (BINARY) (*.PBM)
  # :pcd:: Kodak PhotoCD (*.PCD)
  # :pcsx:: Zsoft Paintbrush PCX bitmap format (*.PCX)
  # :pfm:: Portable Floatmap (*.PFM)
  # :pgm:: Portable Graymap (ASCII) (*.PGM)
  # :pgmraw:: Portable Graymap (BINARY) (*.PGM)
  # :pict:: Macintosh PICT (*.PCT, *.PICT, *.PIC)
  # :png:: Portable Network Graphics (*.PNG)
  # :ppm:: Portable Pixelmap (ASCII) (*.PPM)
  # :ppmraw:: Portable Pixelmap (BINARY) (*.PPM)
  # :psd:: Adobe Photoshop (*.PSD)
  # :ras:: Sun Rasterfile (*.RAS)
  # :raw:: RAW camera image (many extensions)
  # :sgi:: Silicon Graphics SGI image format (*.SGI)
  # :targa:: Truevision Targa files (*.TGA, *.TARGA)
  # :tiff:: Tagged Image File Format (*.TIF, *.TIFF)
  # :wbmp:: Wireless Bitmap (*.WBMP)
  # :xbm:: X11 Bitmap Format (*.XBM)
  # :xpm:: X11 Pitmap Format (*.XPM)
  #
  # :method: formats
  
  FreeImage.enum :format, [:unknown, -1,
                           :bmp, 0,
                           :ico	, 1,
                           :jpeg, 2,
                           :jng	, 3,
                           :koala, 4,
                           :lbm, 5,
                           :iff, 5, # Yes this is intentional!
                           :mng, 6,
                           :pbm, 7,
                           :pbmraw, 8,
                           :pcd, 9,
                           :pcsx, 10,
                           :pgm, 11,
                           :pgmraw, 12,
                           :png, 13,
                           :ppm, 14,
                           :ppmraw, 15,
                           :ras, 16,
                           :targa, 17,
                           :tiff, 18,
                           :wbmp, 19,
                           :psd, 20,
                           :cut, 21,
                           :xbm, 22,
                           :xpm, 23,
                           :dds, 24,
                           :gif, 25,
                           :hdr, 26,
                           :faxg3, 27,
                           :sgi, 28,
                           :exr, 29,
                           :j2k, 30,
                           :jp2, 31,
                           :pfm, 32,
                           :pict, 33,
                           :raw, 34]
end
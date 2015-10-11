module FreeImage
  # == Summary
  #
  # FreeImage can load images from a variety of files,
  # memory or streams.  For additional details please see:
  #
  # FreeImage::File::    Use to load images from files
  # FreeImage::Memory::  Use to load images from byte strings
  # FreeImage::IO::    Use to load images from io streams
  #
  class AbstractSource
    # The Decoder module defines various constants that
    # control how various image formats are loaded.
    module Decoder
      # Load the image header only (not supported by all plugins)
      FIF_LOADNOPIXELS = 0x8000
      GIF_DEFAULT = 0x0
      # Load the image as a 256 color image with ununsed palette entries, if it's 16 or 2 color
      GIF_LOAD256 = 0x1
      # 'Play' the GIF to generate each frame (as 32bpp) instead of returning raw frame data when loading
      GIF_PLAYBACK = 0x2
      ICO_DEFAULT = 0x0
      # Loading (see JPEG_FAST); saving (see JPEG_QUALITYGOOD|JPEG_SUBSAMPLING_420)
      JPEG_DEFAULT = 0x0
      # Load the file as fast as possible, sacrificing some quality
      JPEG_FAST = 0x1
      # Load the file with the best quality, sacrificing some speed
      JPEG_ACCURATE = 0x2
      # Load separated CMYK "as is" (use | to combine with other load flags)
      JPEG_CMYK = 0x4
      # Load and rotate according to Exif 'Orientation' tag if available
      JPEG_EXIFROTATE =0x8
      PCD_DEFAULT = 0x0
      # Load the bitmap sized 768 x 512
      PCD_BASE = 0x1
      # Load the bitmap sized 384 x 256
      PCD_BASEDIV4 = 0x2
      # Load the bitmap sized 192 x 128
      PCD_BASEDIV16 = 0x3
      # Loading: avoid gamma correction
      PNG_IGNOREGAMMA	= 0x1
      PSD_DEFAULT = 0x0
      # Reads tags for separated CMYK (default is conversion to RGB)
      PSD_CMYK = 0x1
      # Reads tags for CIELab (default is conversion to RGB)
      PSD_LAB = 0x2
      # Load the file as linear RGB 48-bit
      RAW_DEFAULT = 0x0
      # Try to load the embedded JPEG preview with included Exif Data or default to RGB 24-bit
      RAW_PREVIEW = 0x1
      # Load the file as RGB 24-bit
      RAW_DISPLAY = 0x2
      # Output a half-size color image
      RAW_HALFSIZE = 0x4
      # If set the loader converts RGB555 and ARGB8888 -> RGB888.
      TARGA_LOAD_RGB888 = 0x1
      # Reads/stores tags for separated CMYK (use | to combine with compression flags)
      TIFF_CMYK = 0x1
    end

    # The Encoder module defines various constants that
    # control how various image formats are saved.
    #
    # Note, some image formats, such as JPEG, reserve an optional integer range for setting the quality level. For example, to save a progressive JPEG with a quality of 90 (out of 100), you'd use the following flag <tt>90 | JPEG_PROGRESSIVE</tt>. For more information, refer to the FreeImage documentation: http://freeimage.sourceforge.net/documentation.html.
    module Encoder
      BMP_DEFAULT = 0x0
      BMP_SAVE_RLE = 0x1
      # Save data as half with piz-based wavelet compression
      EXR_DEFAULT = 0x0
      # Save data as float instead of as half (not recommended)
      EXR_FLOAT = 0x0001
      # Save with no compression
      EXR_NONE = 0x0002
      # Save with zlib compression, in blocks of 16 scan lines
      EXR_ZIP	 = 0x0004
      # Save with piz-based wavelet compression
      EXR_PIZ	 = 0x0008
      # Save with lossy 24-bit float compression
      EXR_PXR24 = 0x0010
      # Save with lossy 44% float compression - goes to 22% when combined with EXR_LC
      EXR_B44 = 0x0020
      # Save images with one luminance and two chroma channels, rather than as RGB (lossy compression)
      EXR_LC = 0x0040
      # Save with a 16:1 rate
      J2K_DEFAULT =	0x0
      # Save with a 16:1 rate
      JP2_DEFAULT =	0x0
      # Loading (see JPEG_FAST); saving (see JPEG_QUALITYGOOD|JPEG_SUBSAMPLING_420)
      JPEG_DEFAULT = 0x0
      # Save with superb quality (100:1)
      JPEG_QUALITYSUPERB = 0x80
      # Save with good quality (75:1)
      JPEG_QUALITYGOOD = 0x0100
      # Save with normal quality (50:1)
      JPEG_QUALITYNORMAL = 0x0200
      # Save with average quality (25:1)
      JPEG_QUALITYAVERAGE = 0x0400
      # Save with bad quality (10:1)
      JPEG_QUALITYBAD = 0x0800
      # Save as a progressive-JPEG (use | to combine with other save flags)
      JPEG_PROGRESSIVE = 0x2000
      # Save with high 4x1 chroma subsampling (4:1:1)
      JPEG_SUBSAMPLING_411 = 0x1000
      # Save with medium 2x2 medium chroma subsampling (4:2:0) - default value
      JPEG_SUBSAMPLING_420 = 0x4000
      # Save with low 2x1 chroma subsampling (4:2:2)
      JPEG_SUBSAMPLING_422 = 0x8000
      # Save with no chroma subsampling (4:4:4)
      JPEG_SUBSAMPLING_444 = 0x10000
      # On saving, compute optimal Huffman coding tables (can reduce a few percent of file size)
      JPEG_OPTIMIZE = 0x20000
      # Save basic JPEG, without metadata or any markers
      JPEG_BASELINE = 0x40000
      PNG_DEFAULT = 0x0
      # Save using ZLib level 1 compression flag (default value is 6)
      PNG_Z_BEST_SPEED = 0x0001
      # Save using ZLib level 6 compression flag (default recommended value)
      PNG_Z_DEFAULT_COMPRESSION = 0x0006
      # Save using ZLib level 9 compression flag (default value is 6)
      PNG_Z_BEST_COMPRESSION = 0x0009
      # Save without ZLib compression
      PNG_Z_NO_COMPRESSION = 0x0100
      # Save using Adam7 interlacing (use | to combine with other save flags)
      PNG_INTERLACED = 0x0200
      PNM_DEFAULT = 0x0
      # If set the writer saves in RAW format (i.e. P4, P5 or P6)
      PNM_SAVE_RAW = 0x0
      # If set the writer saves in ASCII format (i.e. P1, P2 or P3)
      PNM_SAVE_ASCII = 0x1
      TARGA_DEFAULT = 0x0
      # If set, the writer saves with RLE compression
      TARGA_SAVE_RLE = 0x2
      TIFF_DEFAULT = 0x0
      # Reads/stores tags for separated CMYK (use | to combine with compression flags)
      TIFF_CMYK = 0x0001
      # Save using PACKBITS compression
      TIFF_PACKBITS = 0x0100
      # Save using DEFLATE compression (a.k.a. ZLIB compression)
      TIFF_DEFLATE = 0x0200
      # Save using ADOBE DEFLATE compression
      TIFF_ADOBE_DEFLATE = 0x0400
      # Save without any compression
      TIFF_NONE = 0x0800
      # Save using CCITT Group 3 fax encoding
      TIFF_CCITTFAX3 = 0x1000
      # Save using CCITT Group 4 fax encoding
      TIFF_CCITTFAX4 = 0x2000
      # Save using LZW compression
      TIFF_LZW = 0x4000
      # Save using JPEG compression
      TIFF_JPEG = 0x8000
      # Save using LogLuv compression
      TIFF_LOGLUV = 0x10000
    end
    
    # :nodoc: - This method is documented on subclasses
    def open(format = nil, flags = 0)
      format ||= self.format

      # Do we know the format?
      if format == :unknown
        raise(Error.new(:unknown, "Cannot load :unknown image format"))
      end

      # Can we load the image?
      unless FreeImage.FreeImage_FIFSupportsReading(format)
        raise(Error.new("Cannot load image"))
      end

      ptr = load(format, flags)

      # Make sure we didn't get a null pointer.  This can
      # happen - see test_file for example#test_corrupt_wrong_format
      if ptr.null?
        error = Error.new(:unknown, "Could not load the image")
        raise(error)
      end
      Bitmap.new(ptr, self)
    end
  end
end

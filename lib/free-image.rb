# encoding: UTF-8
require 'ffi'
require 'rbconfig'

module FreeImage
  def self.msvc?
    # If this is windows we assume FreeImage was compiled with
    # MSVC since that is the binary distibution provided on
    # the web site.  If you have compiled FreeImage yourself
    # on windows using another compiler, set this to false.
    #
    # This is important because FreeImage defines different
    # type sizes for MSVC - see types/ffi.rb
    FFI::Platform.windows?
  end

  def self.library
    if FFI::Platform.windows?
      'FreeImaged'
    else
      'free_image'
    end
  end

  extend ::FFI::Library
  ffi_lib(library)
  ffi_convention :stdcall if FFI::Platform.windows?
end


# Types
require 'free-image/types/ffi'
require 'free-image/types/boolean'

# More types
require 'free-image/types/rgb_triple'
require 'free-image/types/rgb_quad'
require 'free-image/types/rgb16'
require 'free-image/types/rgba16'
require 'free-image/types/rgbf'
require 'free-image/types/rgbaf'
require 'free-image/types/complex'

# Enums
require 'free-image/enums/color_types'
require 'free-image/enums/dithers'
require 'free-image/enums/filters'
require 'free-image/enums/formats'
require 'free-image/enums/image_types'

# Sources
require 'free-image/sources/abstract_source'
require 'free-image/sources/io'
require 'free-image/sources/file'
require 'free-image/sources/memory'

# Modules
require 'free-image/modules/conversions'
require 'free-image/modules/helper'
require 'free-image/modules/icc'
require 'free-image/modules/information'
require 'free-image/modules/modify'
require 'free-image/modules/pixels'
require 'free-image/modules/transforms'

# Main classes
require 'free-image/errors'
require 'free-image/palette'
require 'free-image/scanline'
require 'free-image/bitmap'
# encoding: UTF-8

module FreeImage
  # Used to specify a color for a :bitmap
  # {image type}[rdoc-ref:FreeImage.images_types].
  #--
  # This structure is packed with pragma (1)
  class RGBQuad < FFI::Struct
    if FFI::Platform::BYTE_ORDER == FFI::Platform::LITTLE_ENDIAN
      layout :blue,     :byte, 0,
             :green,    :byte, 1,
             :red,      :byte, 2,
             :reserved, :byte, 3
    else
      layout :red,      :byte, 0,
             :green,    :byte, 1,
             :blue,     :byte, 2,
             :reserved, :byte, 3
    end

    # Define masks to extract colors from bytes
    if FFI::Platform::BYTE_ORDER == FFI::Platform::LITTLE_ENDIAN
      # Little Endian (x86 / MS Windows, Linux) : BGR(A) order
      RED         = 2
      GREEN		    = 1
      BLUE			  = 0
      ALPHA			  = 3
      RED_MASK	  = 0x00FF0000
      GREEN_MASK  = 0x0000FF00
      BLUE_MASK	  = 0x000000FF
      ALPHA_MASK  = 0xFF000000
      RED_SHIFT   = 16
      GREEN_SHIFT = 8
      BLUE_SHIFT  =	0
      ALPHA_SHIFT =	24
    else
      # Big Endian (PPC / Linux, MaxOSX) : RGB(A) order
      RED			    =	0
      GREEN			  = 1
      BLUE		    =	2
      ALPHA			  = 3
      RED_MASK		= 0xFF000000
      GREEN_MASK	=	0x00FF0000
      BLUE_MASK		= 0x0000FF00
      ALPHA_MASK	=	0x000000FF
      RED_SHIFT		= 24
      GREEN_SHIFT	=	16
      BLUE_SHIFT	=	8
      ALPHA_SHIFT	=	0
    end
    RGB_MASK  = (RED_MASK | GREEN_MASK | BLUE_MASK)

    # Creates a new RGBQuad color
    #
    # == Parameters
    # red:: Value for red, should be between 0 and 255
    # green:: Value for green, should be between 0 and 255
    # blue:: Value for blue, should be between 0 and 255
    # reserved:: Reserved value, by default is 0
    def self.create(red, green, blue, reserved = 0)
      result = self.new
      result[:red] = red
      result[:green] = green
      result[:blue] = blue
      result[:reserved] = reserved
      result
    end

    def eql?(other)
      other.instance_of?(RGBQuad) and
      self[:red]   == other[:red] and
      self[:green] == other[:green] and
      self[:blue]  == other[:blue] and
      self[:reserved]  == other[:reserved]
    end
    alias :== :eql?

    def to_s
      "RGBQuad - Red: #{self[:red]}, Green: #{self[:green]}, Blue: #{self[:blue]}, Alpha: #{self[:reserved]}"
    end
  end
end
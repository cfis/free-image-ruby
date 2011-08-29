# encoding: UTF-8

module FreeImage
  class RGBTriple < FFI::Struct
    if FFI::Platform::BYTE_ORDER == FFI::Platform::LITTLE_ENDIAN
      layout :blue,     :byte, 0,
             :green,    :byte, 1,
             :red,      :byte, 2
    else
      layout :red,      :byte, 0,
             :green,    :byte, 1,
             :blue,     :byte, 2
    end

    # Creates a new RGBTriple color
    #
    # == Parameters
    # red:: Value for red, should be between 0 and 255
    # green:: Value for green, should be between 0 and 255
    # blue:: Value for blue, should be between 0 and 255
    #
    def self.create(red, green, blue)
      result = self.new
      result[:red] = red
      result[:green] = green
      result[:blue] = blue
      result
    end

    def eql?(other)
      other.instance_of?(RGBQuad) and
      self[:red]   == other[:red] and
      self[:green] == other[:green] and
      self[:blue]  == other[:blue]
    end
    alias :== :eql?

    def to_s
      "RGBQuad - Red: #{self[:red]}, Green: #{self[:green]}, Blue: #{self[:blue]}"
    end
  end
end
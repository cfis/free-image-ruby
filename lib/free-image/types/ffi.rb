module FreeImage
  if !self.msvc?
    typedef :int32,  :bool
    typedef :uint8,  :byte
    typedef :uint16, :word
    typedef :uint32, :dword
    typedef :int32,  :long
  else
    typedef :long,   :bool
    typedef :uchar,  :byte
    typedef :ushort, :word
    typedef :ulong,  :dword
  end
end
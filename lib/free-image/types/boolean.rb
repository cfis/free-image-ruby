module FreeImage
  class Boolean
    extend FFI::DataConverter
    native_type :uint32

    def self.to_native(val, ctx)
      val == false ? 0 : 1
    end

    def self.from_native(val, ctx)
      val == 0 ? false : true
    end
  end
end
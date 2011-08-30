module FreeImage
  LAST_ERROR = 'free_image_error'

  #typedef void (*FreeImage_OutputMessageFunction)(FREE_IMAGE_FORMAT fif, const char *msg);
  #typedef void (DLL_CALLCONV *FreeImage_OutputMessageFunctionStdCall)(FREE_IMAGE_FORMAT fif, const char *msg);
  callback(:output_message_callback, [:format, :pointer], :void)

  if FFI::Platform.windows?
    #DLL_API void DLL_CALLCONV FreeImage_SetOutputMessageStdCall(FreeImage_OutputMessageFunctionStdCall omf);
    attach_function('FreeImage_SetOutputMessage', 'FreeImage_SetOutputMessageStdCall', [:output_message_callback], :void)
  else
    #DLL_API void DLL_CALLCONV FreeImage_SetOutputMessage(FreeImage_OutputMessageFunction omf);
    attach_function('FreeImage_SetOutputMessage', [:output_message_callback], :void)
  end

  class Error < StandardError
    attr_reader :format

    def initialize(format, message)
      @format = format
      super(message)
    end

#    def to_s
#      "#{self.message}  Format: #{self.format}"
#    end
  end

  CALLBACK = Proc.new do |format, ptr|
    # Create an exception object and stash it away.  We can't raise it here
    # because FreeImage won't be able to clean up any resources it needs to.
    # Instead, the calling code must call check_last_error.
    message = ptr.get_string(0)
    Thread.current[LAST_ERROR] = Error.new(format, message)
  end
  FreeImage_SetOutputMessage(CALLBACK)

  def check_last_error
    error = Thread.current[LAST_ERROR]
    Thread.current[LAST_ERROR] = nil
    raise(error) if error
  end
  module_function :check_last_error
end
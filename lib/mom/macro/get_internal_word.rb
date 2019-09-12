module Mom
  class GetInternalWord < Macro
    def to_risc(compiler)
      compiler.builder(compiler.source).build do
        object! << message[:receiver]
        integer! << message[:arg1] #"at" is at index 0
        integer.reduce_int
        object << object[integer]
        message[:return_value] << object
      end
    end
  end
end

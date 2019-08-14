module Mom
  module Builtin
    class GetInternalWord < ::Mom::Instruction
      def to_risc(compiler)
        compiler.builder(compiler.source).build do
          object! << message[:receiver]
          integer! << message[:arguments]
          integer << integer[Parfait::NamedList.type_length + 0] #"at" is at index 0
          integer.reduce_int
          object << object[integer]
          message[:return_value] << object
        end
      end
    end
  end
end

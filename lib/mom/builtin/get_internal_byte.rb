module Mom
  module Builtin
    class GetInternalByte < ::Mom::Instruction
      def to_risc(compiler)
        builder = compiler.builder(compiler.source)
        integer_tmp = builder.allocate_int
        builder.build do
          object! << message[:receiver]
          integer! << message[:arguments]
          integer << integer[Parfait::NamedList.type_length + 0] #"at" is at index 0
          integer.reduce_int
          object <= object[integer]
          integer_tmp[Parfait::Integer.integer_index] << object
          message[:return_value] << integer_tmp
        end
        return compiler
      end
    end
  end
end

module Mom
  module Builtin
    class SetInternalByte < ::Mom::Instruction
      def to_risc(compiler)
        compiler.builder(compiler.source).build do
          word! << message[:receiver]
          integer! << message[:arguments]
          integer_reg! << integer[Parfait::NamedList.type_length + 1] #"value" is at index 1
          message[:return_value] << integer_reg
          integer << integer[Parfait::NamedList.type_length + 0] #"at" is at index 0
          integer.reduce_int
          integer_reg.reduce_int
          word[integer] <= integer_reg
        end
        return compiler
      end
    end
  end
end

module Mom
  module Builtin
    class SetInternalByte < ::Mom::Instruction
      def to_risc(compiler)
        compiler.builder(compiler.source).build do
          word! << message[:receiver]
          integer_reg! << message[:arg2] #VALUE
          message[:return_value] << integer_reg
          integer! << message[:arg1] #"index"
          integer.reduce_int
          integer_reg.reduce_int
          word[integer] <= integer_reg
        end
        return compiler
      end
    end
  end
  class SetInternalByte < ::Mom::Instruction
    def to_risc(compiler)
      compiler.builder(compiler.source).build do
        word! << message[:receiver]
        integer_reg! << message[:arg2] #VALUE
        message[:return_value] << integer_reg
        integer! << message[:arg1] #"index"
        integer.reduce_int
        integer_reg.reduce_int
        word[integer] <= integer_reg
      end
      return compiler
    end
  end
end

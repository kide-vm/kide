module Mom
  module Builtin
    class Div4 < ::Mom::Instruction
      def to_risc(compiler)
        builder = compiler.builder(compiler.source)
        integer_tmp = builder.allocate_int
        builder.build do
          integer_self! << message[:receiver]
          integer_self.reduce_int
          integer_1! << 2
          integer_self.op :>> , integer_1
          integer_tmp[Parfait::Integer.integer_index] << integer_self
          message[:return_value] << integer_tmp
        end
        return compiler
      end
    end
  end
  class Div4 < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      integer_tmp = builder.allocate_int
      builder.build do
        integer_self! << message[:receiver]
        integer_self.reduce_int
        integer_1! << 2
        integer_self.op :>> , integer_1
        integer_tmp[Parfait::Integer.integer_index] << integer_self
        message[:return_value] << integer_tmp
      end
      return compiler
    end
  end
end

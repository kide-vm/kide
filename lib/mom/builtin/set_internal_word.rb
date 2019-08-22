module Mom
  module Builtin
    class SetInternalWord < ::Mom::Instruction
      def to_risc(compiler)
        compiler.builder(compiler.source).build do
          object! << message[:receiver]
          integer! << message[:arg1] # "index"
          object_reg! << message[:arg2]#"value"
          integer.reduce_int
          object[integer] << object_reg
          message[:return_value] << object_reg
        end
        return compiler
      end
    end
  end
end

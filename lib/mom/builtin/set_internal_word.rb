module Mom
  module Builtin
    class SetInternalWord < ::Mom::Instruction
      def to_risc(compiler)
        compiler.builder(compiler.source).build do
          object! << message[:receiver]
          integer! << message[:arguments]
          object_reg! << integer[Parfait::NamedList.type_length + 1] #"value" is at index 1
          integer << integer[Parfait::NamedList.type_length + 0] #"at" is at index 0
          integer.reduce_int
          object[integer] << object_reg
          message[:return_value] << object_reg
        end
        return compiler
      end
    end
  end
end

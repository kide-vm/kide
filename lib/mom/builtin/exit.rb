module Mom
  module Builtin
    class Exit < ::Mom::Instruction
      def to_risc(compiler)
        builder = compiler.builder(compiler.source)
        builder.prepare_int_return # makes integer_tmp variable as return
        Builtin.exit_sequence(builder)
        return compiler
      end
    end
  end
end

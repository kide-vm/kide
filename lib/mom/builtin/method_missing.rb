module Mom
  module Builtin
    class MethodMissing < ::Mom::Instruction
      def to_risc(compiler)
        builder = compiler.builder(compiler.source)
        builder.prepare_int_return # makes integer_tmp variable as return
        Builtin.emit_syscall( builder , :exit )
        return compiler
      end
    end
  end
  class MethodMissing < ::Mom::Instruction
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      builder.prepare_int_return # makes integer_tmp variable as return
      Builtin.emit_syscall( builder , :exit )
      return compiler
    end
  end
end

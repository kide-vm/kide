module Mom
  class MethodMissing < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      builder.prepare_int_return # makes integer_tmp variable as return
      Builtin.emit_syscall( builder , :exit )
      return compiler
    end
  end
end

module Mom
  class Exit < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      builder.prepare_int_return # makes integer_tmp variable as return
      Builtin.exit_sequence(builder)
      return compiler
    end
  end
end

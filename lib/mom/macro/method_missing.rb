module Mom
  class MethodMissing < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source_name)
      builder.build do
        factory! << Parfait.object_space.get_factory_for(:Integer)
        integer_tmp! << factory[:reserve]
        Mom::Macro.emit_syscall( builder , :died ) #uses integer_tmp
      end
      return compiler
    end
  end
end

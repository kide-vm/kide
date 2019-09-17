module Mom
  class MethodMissing < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source_name)
      builder.add_code Risc::Syscall.new("Method_missing_died", :died )
      return compiler
    end
  end
end

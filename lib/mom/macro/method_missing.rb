module Mom
  class MethodMissing < Macro
    attr_reader :name

    def initialize( source , name  )
      super(source)
      name = name.value if name.is_a?(Vool::SymbolConstant)
      raise "No reg #{name.class}" unless name.class == Symbol
      @name = name
    end

    def to_risc(compiler)
      builder = compiler.builder(compiler.source_name)
      from = Risc::RegisterValue.new(@name , :Word)
      to = Risc::RegisterValue.new(:r1 , :Word)
      builder.add_code Risc::Transfer.new(self , from , to)
      builder.add_code Risc::Syscall.new(self, :died )
      return compiler
    end
  end
end

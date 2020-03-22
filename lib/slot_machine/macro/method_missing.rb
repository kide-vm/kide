module SlotMachine
  class MethodMissing < Macro
    attr_reader :name_reg

    def initialize( source , name_reg  )
      super(source)
      name_reg = Risc::RegisterValue.new(name_reg , :Word) if  name_reg.class == Symbol
      raise "No reg #{name_reg.class}" unless name_reg.is_a? Risc::RegisterValue
      @name_reg = name_reg
    end

    def to_risc(compiler)
      builder = compiler.builder(compiler.source_name)
      to = Risc::RegisterValue.new(:r1 , :Word)
      builder.add_code Risc::Transfer.new(self , name_reg , to)
      builder.add_code Risc::Syscall.new(self, :died )
      return compiler
    end
  end
end

module SlotMachine
  class IntOperator < Macro
    attr_reader :operator
    def initialize(name , operator)
      super(name)
      @operator = operator
    end

    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      integer_tmp = builder.allocate_int
      operator = @operator # make accessible in block
      builder.build do
        integer = message[:receiver].reduce_int(false)
        integer_reg = message[:arg1].reduce_int(false)
        result = integer.op operator , integer_reg
        integer_tmp[Parfait::Integer.integer_index] << result
        message[:return_value] << integer_tmp
      end
      return compiler
    end
  end
end

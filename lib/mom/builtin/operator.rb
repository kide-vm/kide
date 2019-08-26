module Mom
  module Builtin
    class Operator < Instruction
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
          integer! << message[:receiver]
          integer.reduce_int
          integer_reg! << message[:arg1] #"other"
          integer_reg.reduce_int
          integer.op operator , integer_reg
          integer_tmp[Parfait::Integer.integer_index] << integer
          message[:return_value] << integer_tmp
        end
        return compiler
      end
    end

  end
  class IntOperator < Instruction
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
        integer! << message[:receiver]
        integer.reduce_int
        integer_reg! << message[:arg1] #"other"
        integer_reg.reduce_int
        integer.op operator , integer_reg
        integer_tmp[Parfait::Integer.integer_index] << integer
        message[:return_value] << integer_tmp
      end
      return compiler
    end
  end
end

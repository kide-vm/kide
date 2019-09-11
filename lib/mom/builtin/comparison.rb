module Mom
  module Builtin
    class Comparison < ::Mom::Instruction
      attr_reader :operator
      def initialize(name , operator)
        super(name)
        @operator = operator
      end
      def to_risc(compiler)
        builder = compiler.builder(compiler.source)
        operator = @operator # make accessible in block
        builder.build do
          integer! << message[:receiver]
          integer.reduce_int
          integer_reg! << message[:arg1] #"other"
          integer_reg.reduce_int
          swap_names(:integer , :integer_reg) if(operator.to_s.start_with?('<') )
          integer.op :- , integer_reg
          if_minus false_label
          if_zero( false_label ) if operator.to_s.length == 1
          object! << Parfait.object_space.true_object
          branch merge_label
          add_code false_label
          object << Parfait.object_space.false_object
          add_code merge_label
          message[:return_value] << object
        end
        return compiler
      end
    end
  end
  class Comparison < ::Mom::Instruction
    attr_reader :operator
    def initialize(name , operator)
      super(name)
      @operator = operator.value
    end
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      operator = @operator # make accessible in block
      builder.build do
        integer! << message[:receiver]
        integer.reduce_int
        integer_reg! << message[:arg1] #"other"
        integer_reg.reduce_int
        swap_names(:integer , :integer_reg) if(operator.to_s.start_with?('<') )
        integer.op :- , integer_reg
        if_minus false_label
        if_zero( false_label ) if operator.to_s.length == 1
        object! << Parfait.object_space.true_object
        branch merge_label
        add_code false_label
        object << Parfait.object_space.false_object
        add_code merge_label
        message[:return_value] << object
      end
      return compiler
    end
  end
end

module Vool

  class MacroExpression < CallStatement

    def initialize(name , arguments )
      super(name , SelfExpression.new , arguments)
    end

    def to_slot(compiler)
      parts = name.to_s.split("_")
      class_name = "SlotMachine::#{parts.collect{|s| s.capitalize}.join}"
      eval(class_name).new( self , *arguments)
    end

    # When used as right hand side, this tells what data to move to get the result into
    # a varaible. It is (off course) the return value of the message
    def to_slot_definition(_)
      SlotMachine::SlotDefinition.new(:message ,[ :return_value])
    end

    def to_s(depth = 0)
      sen = "X.#{name}(#{@arguments.collect{|a| a.to_s}.join(', ')})"
      at_depth(depth , sen)
    end

  end
end

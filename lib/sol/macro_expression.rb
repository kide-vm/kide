module Sol

  class MacroExpression < CallStatement

    def initialize(name , arguments )
      super(name , SelfExpression.new , arguments)
    end

    def to_slot(compiler)
      parts = name.to_s.split("_")
      class_name = "SlotMachine::#{parts.collect{|s| s.capitalize}.join}"
      # Hmm, slightly open issue how to pass args from sol to macro
      # WIP, hack for comparison
      args = arguments.collect {|arg|
        case arg
        when Sol::SymbolConstant
          arg.value
        when Sol::IntegerConstant
          arg.value
        when Sol::LocalVariable
          arg.name
        else
          puts "unhandled #{arg}:#{arg.class}"
          arg
        end
      }
      eval(class_name).new( self , *args)
    end

    # When used as right hand side, this tells what data to move to get the result into
    # a varaible. It is (off course) the return value of the message
    def to_slotted(_)
      SlotMachine::Slotted.for(:message ,[ :return_value])
    end

    def to_s(depth = 0)
      sen = "X.#{name}(#{@arguments.collect{|a| a.to_s}.join(', ')})"
      at_depth(depth , sen)
    end

  end
end

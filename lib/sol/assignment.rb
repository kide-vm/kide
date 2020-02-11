module Sol

  # Base class for assignments (local/ivar), works just as you'd expect
  # Only "quirk" maybe, that arguments are like locals
  #
  # Only actual functionality here is the compile_assign_call which compiles
  # the call, should the assigned value be a call.
  class Assignment < Statement
    attr_reader :name , :value
    def initialize(name , value )
      raise "Name nil #{self}" unless name
      raise "Value nil #{self}" unless value
      raise "Value cant be Assignment #{value}" if value.is_a?(Assignment)
      raise "Value cant be Statements #{value}" if value.is_a?(Statements)
      @name , @value = name , value
    end

    def each(&block)
      block.call(self)
      @value.each(&block)
    end

    def to_s(depth = 0)
      at_depth(depth , "#{@name} = #{@value}")
    end

    # The assign instruction (a slot_load) is produced by delegating the slot to derived
    # class
    #
    # When the right hand side is a CallStatement, it must be compiled, before the assign
    # is executed
    #
    # Derived classes do not implement to_slot, only slot_position
    def to_slot(compiler)
      to = SlotMachine::Slot.for(:message , self.slot_position(compiler))
      from = @value.to_slot_definition(compiler)
      assign = SlotMachine::SlotLoad.new(self,to,from)
      return assign unless @value.is_a?(CallStatement)
      @value.to_slot(compiler) << assign
    end
  end
end

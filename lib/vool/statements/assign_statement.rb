module Vool

  class Assignment < Statement
    attr_reader :name , :value
    def initialize(name , value )
      @name , @value = name , value
    end

    def normalize()
      raise "not named left #{name.class}" unless @name.is_a?(Symbol)
      raise "unsupported right #{value}" unless @value.is_a?(Named) or
              @value.is_a?(SendStatement) or @value.is_a?(Constant)
    end

    def chain_assign(assign , method)
      return assign unless @value.is_a?(SendStatement)
      first = @value.to_mom(method)
      first.next = assign
      return first
    end

    def each(&block)
      block.call(self)
      @value.each(&block)
    end
  end

  class IvarAssignment < Assignment

    def normalize()
      super()
      return IvarAssignment.new(@name , @value)
    end

    def to_mom( method )
      to = Mom::SlotDefinition.new(:message ,[ :receiver , @name])
      from = @value.slot_definition(method)
      return chain_assign( Mom::SlotLoad.new(to,from) , method)
    end

  end
end

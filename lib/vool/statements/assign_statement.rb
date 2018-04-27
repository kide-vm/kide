module Vool

  class Assignment < Statement
    attr_reader :name , :value
    def initialize(name , value )
      @name , @value = name , value
    end

    def normalize()
      raise "not named left #{name.class}" unless name.is_a?(Symbol)
      case value
      when Named , Constant
        return copy
      when SendStatement
        return normalize_send
      else
        raise "unsupported right #{value}"
      end
    end

    def copy(value = nil)
      value ||= @value
      self.class.new(name,value)
    end

    def normalize_send
      statements = value.normalize()
      return copy( statements ) if statements.is_a?(SendStatement)
      assign = statements.statements.pop
      statements << copy(assign)
      statements
    end

    def chain_assign(assign , method)
      return assign unless @value.is_a?(SendStatement)
      @value.to_mom(method) << assign
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

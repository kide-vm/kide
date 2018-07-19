module Vool

  class Assignment < Statement
    attr_reader :name , :value
    def initialize(name , value )
      @name , @value = name , value
    end

    def each(&block)
      block.call(self)
      @value.each(&block)
    end

    def to_s(depth = 0)
      at_depth(depth , "#{@name} = #{@value}")
    end

  end

  class IvarAssignment < Assignment

    def to_mom( compiler )
      to = Mom::SlotDefinition.new(:message ,[ :receiver , @name])
      from = @value.slot_definition(compiler)
      return chain_assign( Mom::SlotLoad.new(to,from) , compiler)
    end

  end
end

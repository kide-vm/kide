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


    def chain_assign(assign , compiler)
      return assign unless @value.is_a?(SendStatement)
      @value.to_mom(compiler) << assign
    end
  end
end

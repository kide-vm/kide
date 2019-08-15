module Vool

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

    def chain_assign(assign , compiler)
      return assign unless @value.is_a?(CallStatement)
      raise "Move me to ruby layer"
      @value.to_mom(compiler) << assign
    end
  end
end

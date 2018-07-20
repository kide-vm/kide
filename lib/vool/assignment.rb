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
end

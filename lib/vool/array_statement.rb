module Vool
  class ArrayStatement
    attr_reader :values

    def initialize( values )
      @values = values 
    end

    def length
      @values.length
    end
  end
end

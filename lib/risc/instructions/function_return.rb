module Risc

  # return from a function call
  # register and index specify where the return address is stored

  class FunctionReturn < Instruction
    def initialize( source , register , index)
      super(source)
      @register = register
      @index = index
    end
    attr_reader :register , :index

    def to_s
      "FunctionReturn: #{register} [#{index}]"
    end
  end

  def self.function_return( source , register , index)
    FunctionReturn.new( source , register , index)
  end
end

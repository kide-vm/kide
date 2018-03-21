module Risc

  # return from a function call
  # register specifes where the return address is stored

  class FunctionReturn < Instruction
    def initialize( source , register )
      super(source)
      @register = register
    end
    attr_reader :register

    def to_s
      "FunctionReturn: #{register} "
    end
  end

  def self.function_return( source , register )
    FunctionReturn.new( source , register )
  end
end

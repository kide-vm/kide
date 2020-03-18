module Risc

  # return from a function call
  # register specifes where the return address is stored

  class FunctionReturn < Instruction
    def initialize( source , register )
      super(source)
      @register = register
      raise "Not register #{register}" unless RegisterValue.look_like_reg(register)
    end
    attr_reader :register

    # return an array of names of registers that is used by the instruction
    def register_names
      [register.symbol]
    end

    def to_s
      class_source "#{register} "
    end
  end

  def self.function_return( source , register )
    FunctionReturn.new( source , register )
  end
end

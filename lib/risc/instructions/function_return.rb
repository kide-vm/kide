module Risc

  # return from a function call
  # register specifes where the return address is stored

  class FunctionReturn < Instruction
    def initialize( source , register )
      super(source)
      @register = register
      raise "Not register #{register}" unless RiscValue.look_like_reg(register)
    end
    attr_reader :register

    def to_s
      class_source "#{register} "
    end
  end

  def self.function_return( source , register )
    FunctionReturn.new( source , register )
  end
end

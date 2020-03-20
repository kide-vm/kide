module Risc
  # name says it all really
  # only arg is the method object we want to call
  # assembly takes care of the rest (ie getting the address)

  class FunctionCall < Instruction
    def initialize( source , method)
      super(source)
      @method = method
    end
    attr_reader :method

    # return an array of names of registers that is used by the instruction
    def register_attributes
      []
    end

    def to_s
      class_source method.name
    end
  end

  def self.function_call( source , method )
    Risc::FunctionCall.new( source , method )
  end

end

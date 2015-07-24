module Register
  # name says it all really
  # only arg is the method object we want to call
  # assembly takes care of the rest (ie getting the address)

  class FunctionCall < Instruction
    def initialize method
      @method = method
    end
    attr_reader :method

    def to_s
      "FunctionCall(#{method.name})"
    end

  end
end

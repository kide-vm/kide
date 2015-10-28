module Register
  # name says it all really
  # only arg is the method object we want to call
  # assembly takes care of the rest (ie getting the address)

  class FunctionCall < Instruction
    def initialize source , method
      super(source)
      @method = method
    end
    attr_reader :method

    def to_s
      "FunctionCall: #{method.name}"
    end
  end

  def self.issue_call compiler , callee
    # move the current new_message to message
    compiler.add_code RegisterTransfer.new("__call__", Register.new_message_reg , Register.message_reg )
    # do the register call
    compiler.add_code FunctionCall.new( "__call__" , callee )
  end
end

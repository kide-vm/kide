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

  def self.issue_call( compiler , callee )
    source = "_issue_call(#{callee.name})"
    return_label = Label.new("_return_label" , "#{compiler.type.object_class.name}.#{compiler.method.name}" )
    ret_tmp = compiler.use_reg(:Label)
    compiler.add_code Register::LoadConstant.new(source, return_label , ret_tmp)
    compiler.add_code Register.reg_to_slot(source, ret_tmp , :new_message , :return_address)
    # move the current new_message to message
    compiler.add_code RegisterTransfer.new(source, Register.new_message_reg , Register.message_reg )
    # do the register call
    compiler.add_code FunctionCall.new( source , callee )
    compiler.add_code return_label
    # move the current message to new_message
    compiler.add_code  Register::RegisterTransfer.new(source, Register.message_reg , Register.new_message_reg )
    # and restore the message from saved value in new_message
    compiler.add_code Register.get_slot(source , :new_message , :caller , :message )
  end
end

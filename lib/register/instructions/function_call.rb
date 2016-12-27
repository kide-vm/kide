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
    return_label = Label.new("_return_label #{callee.name}" , "#{compiler.type.object_class.name}.#{compiler.method.name}" )
    ret_tmp = compiler.use_reg(:Label)
    compiler.add_code Register::LoadConstant.new("#{callee.name} load ret", return_label , ret_tmp)
    compiler.add_code Register.reg_to_slot("#{callee.name} store ret", ret_tmp , :new_message , :return_address)
    compiler.add_code RegisterTransfer.new("#{callee.name} move new message", Register.new_message_reg , Register.message_reg )
    compiler.add_code FunctionCall.new( "#{callee.name} call" , callee )
    compiler.add_code return_label
    compiler.add_code Register::RegisterTransfer.new("#{callee.name} remove new message", Register.message_reg , Register.new_message_reg )
    compiler.add_code Register.slot_to_reg("#{callee.name} restore message" , :new_message , :caller , :message )
  end
end

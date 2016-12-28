module Register
  # name says it all really
  # only arg is the method object we want to call
  # assembly takes care of the rest (ie getting the address)

  class FunctionCall < Instruction
    def initialize( source , method )
      super(source)
      @method = method
    end
    attr_reader :method

    def to_s
      "FunctionCall: #{method.name}"
    end
  end

  def self.function_call( source , method )
    Register::FunctionCall.new( source , method )
  end

  def self.issue_call( compiler , callee )
    return_label = Register.label("_return_label #{callee.name}" , "#{compiler.type.object_class.name}.#{compiler.method.name}" )
    ret_tmp = compiler.use_reg(:Label)
    compiler.add_load_constant("#{callee.name} load ret", return_label , ret_tmp)
    compiler.add_reg_to_slot("#{callee.name} store ret", ret_tmp , :new_message , :return_address)
    compiler.add_transfer("#{callee.name} move new message", Register.new_message_reg , Register.message_reg )
    compiler.add_code Register.function_call( "#{callee.name} call" , callee )
    compiler.add_code return_label
    compiler.add_transfer("#{callee.name} remove new message", Register.message_reg , Register.new_message_reg )
    compiler.add_slot_to_reg("#{callee.name} restore message" , :new_message , :caller , :message )
  end
end

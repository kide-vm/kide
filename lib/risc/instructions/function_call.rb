module Risc
  # name says it all really
  # only arg is the method object we want to call
  # assembly takes care of the rest (ie getting the address)

  class FunctionCall < Instruction
    def initialize( source , method , register)
      super(source)
      @method = method
      @register = register
    end
    attr_reader :method , :register

    def to_s
      class_source method.name
    end
  end

  def self.function_call( source , method , register)
    Risc::FunctionCall.new( source , method , register)
  end

  def self.issue_call( compiler , callee )
    callee_name = callee.name
    return_label = Risc.label("_return_label #{callee_name}" , "#{compiler.type.object_class.name}.#{compiler.method.name}" )
    ret_tmp = compiler.use_reg(:Label)
    compiler.add_load_constant("#{callee_name} load ret", return_label , ret_tmp)
    compiler.add_reg_to_slot("#{callee_name} store ret", ret_tmp , :new_message , :return_address)
    compiler.add_transfer("#{callee_name} move new message", Risc.new_message_reg , Risc.message_reg )
    compiler.add_function_call( "#{callee_name} call" , callee )
    compiler.add_code return_label
    compiler.add_transfer("#{callee_name} remove new message", Risc.message_reg , Risc.new_message_reg )
    compiler.add_slot_to_reg("#{callee_name} restore message" , :new_message , :caller , :message )
  end
end

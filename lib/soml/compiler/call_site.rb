module Soml
  Compiler.class_eval do

    def on_call statement
      #puts statement
      name_s , arguments , receiver = *statement
      name = name_s.to_a.first
      raise "not inside method " unless @method
      reset_regs
      #move the new message (that we need to populate to make a call) to std register
      new_message = Register.resolve_to_register(:new_message)
      add_code Register.get_slot(statement, :message , :next_message , new_message )
      if receiver
        me = process( receiver.first  )
      else
        me = use_reg @method.for_class.name
        add_code Register.get_slot(statement, :message , :receiver , me )
      end
      if(me.type == :Class)
        clazz = me.value.meta
      else
        # now we have to resolve the method name (+ receiver) into a callable method
        clazz =  Register.machine.space.get_class_by_name(me.type)
      end
      # move our receiver there
      add_code Register.set_slot( statement , me , :new_message , :receiver)
      set_message_details(name_s , arguments)
      set_arguments(arguments)
      #puts "clazz #{clazz.name}"
      raise "No such class #{me.type}" unless clazz
      method = clazz.get_instance_method(name)
      #puts Register.machine.space.get_class_by_name(:Integer).method_names.to_a
      raise "Method not implemented #{me.type}.#{name}" unless method
      Register.issue_call( self , method )
      ret = use_reg( :Integer )
      # the effect of the method is that the NewMessage Return slot will be filled, return it
      # but move it into a register too
      add_code Register.get_slot(statement, :message , :return_value , ret )
      ret
    end
    private
    def set_message_details name_s , arguments
      name = name_s.to_a.first
      # load method name and set to new message (for exceptions/debug)
      name_tmp = use_reg(:Word)
      add_code Register::LoadConstant.new(name_s, name , name_tmp)
      add_code Register.set_slot( name_s , name_tmp , :new_message , :name)
      # next arguments. first length then args
      len_tmp = use_reg(:Integer , arguments.to_a.length )
      add_code Register::LoadConstant.new(arguments, arguments.to_a.length , len_tmp)
      add_code Register.set_slot( arguments , len_tmp , :new_message , :indexed_length)

    end
    def set_arguments arguments
      # reset tmp regs for each and load result into new_message
      arguments.to_a.each_with_index do |arg , i|
        reset_regs
        # processing should return the register with the value
        val = process( arg)
        raise "Not register #{val}" unless val.is_a?(Register::RegisterValue)
        # which we load int the new_message at the argument's index (the one comes from c index)
        set = Register.set_slot( arg , val , :new_message , Parfait::Message.get_indexed(i+1))
        add_code set
      end
    end
  end
end

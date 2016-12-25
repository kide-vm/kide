module Typed
  module CallSite

    def on_CallSite( statement )
#      name_s , arguments , receiver = *statement
      raise "not inside method " unless @method
      reset_regs
      #move the new message (that we need to populate to make a call) to std register
      new_message = Register.resolve_to_register(:new_message)
      add_code Register.slot_to_reg(statement, :message , :next_message , new_message )
      me = get_me( statement )
      type = get_my_type(me)
      # move our receiver there
      add_code Register.reg_to_slot( statement , me , :new_message , :receiver)

      set_message_details(statement , statement.arguments)
      set_arguments(statement.arguments)
      ret = use_reg( :Integer ) #FIXME real return type
      do_call(type , statement)
      # the effect of the method is that the NewMessage Return slot will be filled, return it
      # but move it into a register too
      add_code Register.slot_to_reg(statement, :new_message , :return_value , ret )
      ret
    end

    private

    def get_me( statement )
      if statement.receiver
        me = process( statement.receiver  )
      else
        me = use_reg @method.for_type
        add_code Register.slot_to_reg(statement, :message , :receiver , me )
      end
      me
    end
    def get_my_type( me )
      # now we have to resolve the method name (+ receiver) into a callable method
      case me.type
      when Parfait::Type
        type = me.type
      when Symbol
        type =  Register.machine.space.get_class_by_name(me.type).instance_type
      else
        raise me.inspect
      end
      raise "Not type #{type}" unless type.is_a? Parfait::Type
      type
    end

    def do_call( type , statement )
      name = statement.name
      #puts "type #{type.inspect}"
      method = type.get_instance_method(name)
      #puts type.method_names.to_a
      raise "Method not implemented #{type.inspect}.#{name}" unless method
      Register.issue_call( self , method )
    end

    # load method name and set to new message (for exceptions/debug)
    def set_message_details name_s , arguments
      name = name_s.name
      name_tmp = use_reg(:Word)
      add_code Register::LoadConstant.new(name_s, name , name_tmp)
      add_code Register.reg_to_slot( name_s , name_tmp , :new_message , :name)
      # next arg and local types
      args_reg = use_reg(:Type , @method.arguments )
      list_reg = use_reg(:NamedList , arguments )
      add_code Register::LoadConstant.new(name_s, @method , args_reg)
      add_code Register.slot_to_reg( name_s , :message , :arguments , list_reg )
      add_code Register.reg_to_slot( name_s , args_reg , list_reg , 1  )

#FIXME need to set type of locals too. sama sama
#      len_tmp = use_reg(:Integer , arguments.to_a.length )
#      add_code Register::LoadConstant.new(name_s, arguments.to_a.length , len_tmp)
#      add_code Register.reg_to_slot( name_s , len_tmp , :new_message , :indexed_length)
    end
    def set_arguments arguments
      # reset tmp regs for each and load result into new_message
      arguments.to_a.each_with_index do |arg , i|
        reset_regs
        # processing should return the register with the value
        val = process( arg)
        raise "Not register #{val}" unless val.is_a?(Register::RegisterValue)
        list_reg = use_reg(:NamedList , arguments )
        add_code Register.slot_to_reg( "Set arg #{i}#{arg}" , :message , :arguments , list_reg )
        # which we load int the new_message at the argument's index (the one comes from c index)
        set = Register.reg_to_slot( arg , val , list_reg , i + 1 )
        add_code set
      end
    end
  end
end

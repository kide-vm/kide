module Vm
  module CallSite

    def on_CallSite( statement )
      raise "not inside method " unless @method
      reset_regs
      #move the new message (that we need to populate to make a call) to std register
      load_new_message(statement)
      me = get_me( statement )
      type = get_my_type(me)

      method = type.get_method(statement.name)
      raise "Method not implemented for me:#{me} #{type.inspect}.#{statement.name}" unless method

      # move our receiver there
      add_reg_to_slot( statement , me , :new_message , :receiver)

      set_message_details(method , statement , statement.arguments)
      set_arguments(method , statement.arguments)
      ret = use_reg( :Object ) #FIXME real return type

      Register.issue_call( self , method )

      # the effect of the method is that the NewMessage Return slot will be filled, return it
      # but move it into a register too
      add_slot_to_reg(statement, :new_message , :return_value , ret )
      ret
    end

    private

    def load_new_message(statement)
      new_message = Register.resolve_to_register(:new_message)
      add_slot_to_reg(statement, :message , :next_message , new_message )
      new_message
    end

    def get_me( statement )
      if statement.receiver
        me = process( statement.receiver  )
      else
        me = use_reg @method.for_type
        add_slot_to_reg(statement, :message , :receiver , me )
      end
      me
    end

    def get_my_type( me )
      # now we have to resolve the method name (+ receiver) into a callable method
      case me.type
      when Parfait::Type
        type = me.type
      when Symbol
        type =  Parfait.object_space.get_class_by_name(me.type).instance_type
      else
        raise me.inspect
      end
      raise "Not type #{type}" unless type.is_a? Parfait::Type
      type
    end

    # load method name and set to new message (for exceptions/debug)
    def set_message_details( method , name_s , arguments )
      name = name_s.name
      name_tmp = use_reg(:Word)
      add_load_constant("#{name} load method name", name , name_tmp)
      add_reg_to_slot( "#{name} store method name" , name_tmp , :new_message , :name)
      # next arg type
      args_reg = use_reg(:Type , method.arguments )
      list_reg = use_reg(:NamedList , arguments )
      add_load_constant("#{name} load arguments type", method.arguments , args_reg)
      add_slot_to_reg( "#{name} get args from method" , :new_message , :arguments , list_reg )
      add_reg_to_slot( "#{name} store args type in args" , args_reg , list_reg , 1  )
    end

    def set_arguments( method , arguments )
      # reset tmp regs for each and load result into new_message
      arg_type = method.arguments
      message = "Arg number mismatch, method=#{arg_type.instance_length - 1} , call=#{arguments.length}"
      raise  message if (arg_type.instance_length - 1 ) != arguments.length
      arguments.each_with_index do |arg , i |
        store_arg_no(arguments , arg_type , arg , i + 1) #+1 for ruby(0 based)
      end
    end

    def store_arg_no(arguments , arg_type , arg , i )
      reset_regs
      i = i + 1             # disregarding type field
      val = process( arg)   # processing should return the register with the value
      raise "Not register #{val}" unless val.is_a?(Register::RegisterValue)
      #FIXME definately needs some tests
      raise "TypeMismatch calling with #{val.type} , instead of #{arg_type.type_at(i)}" if val.type != arg_type.type_at(i)
      list_reg = use_reg(:NamedList , arguments )
      add_slot_to_reg( "Set arg #{i}:#{arg}" , :new_message , :arguments , list_reg )
      # which we load int the new_message at the argument's index
      add_reg_to_slot( arg , val , list_reg , i ) #one for type and one for ruby
    end
  end
end

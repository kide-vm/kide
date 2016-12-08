module Typed
  Compiler.class_eval do

    def on_Assignment statement
      reset_regs # statements reset registers, ie have all at their disposal
      #puts statement.inspect
#      name , value = *statement
      name_s = no_space statement.name
      v = process(statement.value)
      raise "Not register #{v}" unless v.is_a?(Register::RegisterValue)
      code = nil
      if( index = @method.has_arg(name_s.name))
         # TODO, check type @method.arguments[index].type
        code = Register.set_slot(statement , v , :message , Parfait::Message.get_indexed(index) )
      else # or a local so it is in the frame
        index = @method.has_local( name_s.name )
        if(index)
          # TODO, check type  @method.locals[index].type
          frame = use_reg(:Frame)
          add_code Register.get_slot(statement , :message , :frame , frame )
          code = Register.set_slot(statement , v , frame , Parfait::Frame.get_indexed(index) )
        end
      end
      if( code )
        #puts "addin code #{code}"
        add_code code
      else
        raise "must define variable #{name} before using it in #{@method.inspect}"
      end
    end

  end
end

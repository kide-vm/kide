module Soml
  Compiler.class_eval do

      #    attr_reader  :name
      # compiling name needs to check if it's a variable and if so resolve it
      # otherwise it's a method without args and a send is issued.
      # whichever way this goes the result is stored in the return slot (as all compiles)
      def on_name statement
        name = statement.to_a.first
        if( name == :self)
          ret = use_reg @clazz.name
          add_code Register.get_slot(statement , :message , :receiver , ret )
          return ret
        end
        if(name == :space)
          space = Parfait::Space.object_space
          reg = use_reg :Space , space
          add_code Register::LoadConstant.new( statement, space , reg )
          return reg
        end
        if(name == :message)
          reg = use_reg :Message
          add_code Register::RegisterTransfer.new( statement, Register.message_reg , reg )
          return reg
        end
        # either an argument, so it's stored in message
        if( index = @method.has_arg(name))
          ret = use_reg @method.arguments[index].type
          add_code Register.get_slot(statement , :message , Parfait::Message.get_indexed(index), ret )
          return ret
        else # or a local so it is in the frame
          index = @method.has_local( name )
          if(index)
            frame = use_reg :Frame
            add_code Register.get_slot(statement , :message , :frame , frame )
            ret = use_reg @method.locals[index].type
            add_code Register.get_slot(statement , frame , Parfait::Frame.get_indexed(index), ret )
            return ret
          end
        end
        raise "must define variable #{name} before using it"
      end

  end #module
end

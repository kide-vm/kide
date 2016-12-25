module Typed
  module NameExpression

      #    attr_reader  :name
      # compiling name needs to check if it's a local variable
      # or an argument
      # whichever way this goes the result is stored in the return slot (as all compiles)
      def on_NameExpression statement
        name = statement.name
        [:self , :space , :message].each do |special|
          return send(:"handle_special_#{special}" , statement ) if name == special
        end
        # either an argument, so it's stored in message
        if( index = @method.has_arg(name))
          ret = use_reg @method.argument_type(index)
          #puts "For #{name} at #{index} got #{@method.arguments.inspect}"
          add_code Register.slot_to_reg(statement , :message , index, ret )
          return ret
        end
        # or a local so it is in the named_list
        handle_local(statement)
      end

      private

      def handle_local statement
        index = @method.has_local( statement.name )
        raise "must define variable '#{statement.name}' before using it" unless index
        named_list = use_reg :NamedList
        add_code Register.slot_to_reg(statement , :message , :locals , named_list )
        ret = use_reg @method.locals_type( index )
        add_code Register.slot_to_reg(statement , named_list , index, ret )
        return ret
      end

      def handle_special_self(statement)
        ret = use_reg @type
        add_code Register.slot_to_reg(statement , :message , :receiver , ret )
        return ret
      end

      def handle_special_space(statement)
        space = Parfait::Space.object_space
        reg = use_reg :Space , space
        add_code Register::LoadConstant.new( statement, space , reg )
        return reg
      end
      def handle_special_message(statement)
        reg = use_reg :Message
        add_code Register::RegisterTransfer.new( statement, Register.message_reg , reg )
        return reg
      end
  end #module
end

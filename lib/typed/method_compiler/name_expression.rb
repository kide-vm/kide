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
          named_list = use_reg :NamedList
          ret = use_reg @method.argument_type(index)
          #puts "For #{name} at #{index} got #{@method.arguments.inspect}"
          add_code Register.slot_to_reg("#{statement} load args" , :message , :arguments, named_list )
          add_code Register.slot_to_reg("#{statement} load #{name}" , named_list , index + 1, ret )
          return ret
        end
        # or a local so it is in the named_list
        handle_local(statement)
      end

      private

      def handle_local( statement )
        name = statement.name
        index = @method.has_local( name )
        raise "must define variable '#{name}' before using it" unless index
        named_list = use_reg :NamedList
        add_code Register.slot_to_reg("#{name} load locals" , :message , :locals , named_list )
        ret = use_reg @method.locals_type( index )
        add_code Register.slot_to_reg("#{name} load from locals" , named_list , index + 1, ret )
        return ret
      end

      def handle_special_self(statement)
        ret = use_reg @type
        add_code Register.slot_to_reg("#{statement} load self" , :message , :receiver , ret )
        return ret
      end

      def handle_special_space(statement)
        space = Parfait::Space.object_space
        reg = use_reg :Space , space
        add_code Register.load_constant( "#{statement} load space", space , reg )
        return reg
      end

      def handle_special_message(statement)
        reg = use_reg :Message
        add_code Register.transfer( "#{statement} load message", Register.message_reg , reg )
        return reg
      end
  end #module
end

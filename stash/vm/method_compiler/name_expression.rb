module Vm
  module NameExpression

      #    attr_reader  :name
      # compiling name needs to check if it's a local variable
      # or an argument
      # whichever way this goes the result is stored in the return slot (as all compiles)
      def on_KnownName statement
        name = statement.name
        [:self , :space , :message].each do |special|
          return send(:"load_special_#{special}" , statement ) if name == special
        end
        raise "Unknow 'known' expression #{name}"
      end

      def on_ArgumentName(statement)
        name = statement.name
        index = @method.has_argument(name)
        raise "no arg #{name}" unless index
        named_list = use_reg :NamedList
        ret = use_reg @method.arguments_type(index)
        #puts "For #{name} at #{index} got #{@method.arguments.inspect}"
        add_slot_to_reg("#{statement} load args" , :message , :arguments, named_list )
        add_slot_to_reg("#{statement} load #{name}" , named_list , index + 1, ret )
        return ret
      end

      def on_LocalName( statement )
        name = statement.name
        index = @method.has_local( name )
        raise "must define local '#{name}' before using it" unless index
        named_list = use_reg :NamedList
        add_slot_to_reg("#{name} load locals" , :message , :frame , named_list )
        ret = use_reg @method.frame_type( index )
        add_slot_to_reg("#{name} load from locals" , named_list , index + 1, ret )
        return ret
      end

      def load_special_self(statement)
        ret = use_reg @type
        add_slot_to_reg("#{statement} load self" , :message , :receiver , ret )
        return ret
      end

      def load_special_space(statement)
        space = Parfait.object_space
        reg = use_reg :Space , space
        add_load_constant( "#{statement} load space", space , reg )
        return reg
      end

      def load_special_message(statement)
        reg = use_reg :Message
        add_transfer( "#{statement} load message", Risc.message_reg , reg )
        return reg
      end
  end #module
end

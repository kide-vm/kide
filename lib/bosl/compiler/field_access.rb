module Bosl
  Compiler.class_eval do

    def on_field_access expression
      #puts expression.inspect
      receiver_ast , field_ast = *expression
      receiver = receiver_ast.first_from(:name)
      field_name = field_ast.first_from(:name)

      case receiver
      when :self
        index = @clazz.object_layout.variable_index(field_name)
        raise "field access, but no such field:#{field_name} for class #{@clazz.name}" unless index
        value = Virtual::Return.new(:int)
        @method.source.add_code Virtual::Set.new( Virtual::SelfsSlot.new(index, :int ) , value )
      when :message
        #message Slot
        raise "message not yet"
      else
        #arg / frame Slot
        raise "frame not implemented"
      end

      value
    end
  end
end

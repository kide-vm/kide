module Bosl
  Compiler.class_eval do

    def on_field_access expression
      #puts expression.inspect
      receiver_ast , field_ast = *expression
      receiver = receiver_ast.first_from(:name)
      field_name = field_ast.first_from(:name)

      case receiver
      when :self
        for_class = self.method.for_class
        index = for_class.object_layout.variable_index(field_name)
        raise "field access, but no such field:#{field_name} for class #{for_class.name}" unless index
        value = Virtual::Return.new(:int)
        method.source.add_code Virtual::Set.new( Virtual::SelfSlot.new(index, :int ) , value )
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

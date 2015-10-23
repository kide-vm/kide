module Phisol
  Compiler.class_eval do

    def on_field_access statement
      #puts statement.inspect
      receiver_ast , field_ast = *statement
      receiver = receiver_ast.first_from(:name)
      field_name = field_ast.first_from(:name)

      case receiver
      when :self
        index = @clazz.object_layout.variable_index(field_name)
        raise "field access, but no such field:#{field_name} for class #{@clazz.name}" unless index
        value = use_reg(@clazz.name) #TODO incorrect, this is the self, but should be the type of variable at index 
        add_code Register.get_slot(statement , :message , :receiver , value )
        # reuse the register for next move
        move = Register.get_slot(statement, value , index , value )
        add_code move
        return value
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

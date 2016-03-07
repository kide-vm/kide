module Soml
  Compiler.class_eval do

    def on_FieldAccess statement
#      receiver_ast , field_ast = *statement
      receiver = process(statement.receiver)

      clazz = Register.machine.space.get_class_by_name receiver.type

      field_name = statement.field.name


      index = clazz.instance_type.variable_index(field_name)
      raise "field access, but no such field:#{field_name} for class #{clazz.name}" unless index
      value = use_reg(clazz.instance_type.type_at(index))

      add_code Register.get_slot(statement , receiver , index, value)

      value
    end

    def on_receiver expression
      process expression.first
    end
  end
end

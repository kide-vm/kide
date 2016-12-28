module Typed
  module FieldAccess

    def on_FieldAccess statement
#      receiver_ast , field_ast = *statement
      receiver = process(statement.receiver)

      type = receiver.type
      if(type.is_a?(Symbol))
        type = Parfait::Space.object_space.get_class_by_name(type).instance_type
      end
      field_name = statement.field.name

      index = type.variable_index(field_name)
      raise "no such field:#{field_name} for class #{type.inspect}" unless index
      value = use_reg(type.type_at(index))

      add_slot_to_reg(statement , receiver , index, value)

      value
    end

    def on_receiver expression
      process expression.first
    end
  end
end

module Typed
  module ClassField

    def on_ClassField statement
      #type , name , value = *statement

      for_type = @type
      raise "no type" unless for_type
      index = for_type.variable_index(statement.name)
      raise "class field already defined:#{name} for class #{for_type}" if index

      #FIXME should not hack into current type, but create a new
      for_type.send(:private_add_instance_variable, statement.name , statement.type)

      return nil # statements don't reurn values, only expressions
    end
  end
end

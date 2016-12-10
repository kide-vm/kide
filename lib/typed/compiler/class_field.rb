module Typed
  module ClassField

    def on_ClassField statement
      #type , name , value = *statement

      for_class = @clazz
      raise "no class" unless for_class
      index = for_class.instance_type.variable_index(statement.name)
      raise "class field already defined:#{name} for class #{for_class.name}" if index

      #FIXME should not hack into current type, but create a new
      for_class.instance_type.send(:private_add_instance_variable, statement.name , statement.type)

      return nil # statements don't reurn values, only expressions
    end
  end
end

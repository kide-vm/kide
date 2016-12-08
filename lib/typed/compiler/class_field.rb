module Typed
  Compiler.class_eval do

    def on_ClassField statement
      #puts statement.inspect
      #type , name , value = *statement

      for_class = @clazz
      raise "no class" unless for_class
      index = for_class.instance_type.variable_index(statement.name)
      #raise "class field already defined:#{name} for class #{for_class.name}" if index
      #puts "Define field #{name} on class #{for_class.name}"
      for_class.instance_type.add_instance_variable( statement.name , statement.type )

      return nil # statements don't reurn values, only expressions
    end
  end
end

module Soml
  Compiler.class_eval do

    def on_class_field statement
      #puts statement.inspect
      type , name , value = *statement

      for_class = @clazz
      raise "no class" unless for_class
      index = for_class.object_layout.variable_index(name)
      #raise "class field already defined:#{name} for class #{for_class.name}" if index
      #puts "Define field #{name} on class #{for_class.name}"
      index = for_class.object_layout.add_instance_variable( name , type )

      # not sure how to run class code yet. later
      raise "value #{value}" if value

      return nil # statements don't reurn values, only expressions
    end
  end
end

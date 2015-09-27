module Bosl
  Compiler.class_eval do

    def on_class_field expression
      puts expression.inspect
      type , name , value = *expression

      for_class = self.method.for_class
      index = for_class.object_layout.variable_index(name)
      raise "class field already defined:#{name} for class #{for_class.name}" if index
      puts "Define field #{name} on class #{for_class.name}"
      index = for_class.object_layout.add_instance_variable( name ) #TODO need typing

      if value
        value = process( value  )
        raise "value #{value}" #tbc
      end

      Virtual::Return.new( index )
    end
  end
end

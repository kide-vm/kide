module Typed
  Compiler.class_eval do

    def on_ClassStatement statement
      #puts statement.inspect
      raise "classes dont yet play babushka, get coding #{name}" if @clazz
      @clazz = Parfait::Space.object_space.get_class_by_name! statement.name
      #puts "Compiling class #{@clazz.name.inspect}"
      statement_value = process(statement.statements).last
      @clazz = nil
      return statement_value
    end
  end
end

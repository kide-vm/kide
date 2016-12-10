module Typed
  module ClassStatement

    def on_ClassStatement statement

      raise "classes dont yet play babushka, get coding #{statement.name}" if @clazz

      @clazz = Parfait::Space.object_space.get_class_by_name! statement.name
      #puts "Compiling class #{@clazz.name.inspect}"
      statement_value = process(statement.statements).last
      @clazz = nil
      return statement_value
    end
  end
end

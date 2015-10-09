module Phisol
  Compiler.class_eval do

    def on_class statement
      #puts statement.inspect
      name , derives , statements = *statement
      raise "classes dont yet play babushka, get coding #{name}" if @clazz
      @clazz = Parfait::Space.object_space.get_class_by_name! name
      puts "Compiling class #{@clazz.name.inspect}"
      statement_value = process_all(statements).last
      @clazz = nil
      return statement_value
    end
  end
end

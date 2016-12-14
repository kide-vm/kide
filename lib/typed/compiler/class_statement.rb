module Typed
  module ClassStatement

    def on_ClassStatement statement

      raise "classes dont yet play babushka, get coding #{statement.name}" if @type

      @type = Parfait::Space.object_space.get_class_by_name!(statement.name).instance_type
      #puts "Compiling class #{@type.inspect}"
      statement_value = process(statement.statements).last
      @type = nil
      return statement_value
    end
  end
end

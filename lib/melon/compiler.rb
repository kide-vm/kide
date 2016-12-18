require_relative "type_collector"


module Melon
  class Compiler < AST::Processor

    def self.compile input
      ast = Parser::Ruby22.parse input
      compiler = self.new
      compiler.process ast
    end

    def get_name( statement )
      return nil unless statement
      statement.children[1]
    end

    def on_class statement
      name , sup , body = *statement
      clazz = Parfait::Space.object_space.create_class(get_name(name) , get_name(sup) )
      clazz.set_instance_names( TypeCollector.new.collect(body) )
    end
  end
end

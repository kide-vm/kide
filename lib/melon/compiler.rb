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
      ivar_hash = TypeCollector.new.collect(body)
      clazz.set_instance_type( Parfait::Type.for_hash( clazz ,  ivar_hash ) ) 
    end
  end
end

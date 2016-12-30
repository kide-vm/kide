require_relative "compiler/total_processor"
require_relative "compiler/type_collector"
require_relative "compiler/method_collector"
require_relative "compiler/locals_collector"
require_relative "compiler/ruby_method"


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
      clazz = Parfait.object_space.create_class(get_name(name) , get_name(sup) )
      ivar_hash = TypeCollector.new.collect(body)
      clazz.set_instance_type( Parfait::Type.for_hash( clazz ,  ivar_hash ) )

      MethodCollector.new.collect(body)

    end

    def handler_missing(node)
      node.children.each do |kid |
        process(kid) if kid.is_a?(AST::Node)
      end
    end

  end
end

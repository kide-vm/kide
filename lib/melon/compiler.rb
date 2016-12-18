

module Melon
  class Compiler < AST::Processor

    def self.compile input
      ast = Parser::Ruby22.parse input
      compiler = self.new
      compiler.process ast
    end

    def on_class statement
      name , _ , _ = *statement
      clazz_name = name.children[1]
      Parfait::Space.object_space.create_class(clazz_name , nil )
    end
  end
end

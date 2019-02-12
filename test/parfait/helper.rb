require_relative "../helper"

module Parfait
  class ParfaitRewriter < AST::Processor
    include AST::Sexp

    def rewrite(input)
      ast = Parser::Ruby22.parse( input )
      new_ast = process(ast)
      new_ast.to_s
    end

  end
end

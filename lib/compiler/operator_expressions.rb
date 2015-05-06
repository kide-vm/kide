module Compiler
#    operator attr_reader  :operator, :left, :right
    def self.compile_operator expression, method
      call = Ast::CallSiteExpression.new(expression.operator , [expression.right] , expression.left )
      Compiler.compile(call, method)
    end
end

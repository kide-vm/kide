module Ast
  class OperatorExpression < Expression
#    attr_reader  :operator, :left, :right
    def compile method , message
      call = CallSiteExpression.new( operator , [right] , left )
      call.compile(method,message)
    end
  end
end
module Ast
  class OperatorExpression < Expression
#    attr_reader  :operator, :left, :right
    def compile method , frame
      call = CallSiteExpression.new( operator , [right] , left )
      call.compile(method,frame)
    end
  end
end
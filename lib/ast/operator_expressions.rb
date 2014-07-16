module Ast
  class OperatorExpression < Expression
#    attr_reader  :operator, :left, :right
    def compile frame , method
      call = CallSiteExpression.new( operator , [right] , left )
      call.compile(frame , method)
    end
  end
end
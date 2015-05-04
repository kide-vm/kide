module Compiler
#    operator attr_reader  :operator, :left, :right
    def compile_operator expression, method , message
      call = CallSiteExpression.new( operator , [right] , left )
      call.compile(method,message)
    end
end

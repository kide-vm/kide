module Typed
  module Tree
    class OperatorExpression < Expression
      attr_accessor :operator , :left_expression , :right_expression
    end
  end
end

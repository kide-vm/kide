module Typed
  module Tree
    class OperatorExpression < Expression
      attr_accessor :operator , :left_expression , :right_expression
      def to_s
        "#{left_expression} #{operator} #{right_expression}"
      end
    end
  end
end

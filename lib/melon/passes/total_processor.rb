module Melon

  module Passes
    class TotalProcessor < AST::Processor

      def handler_missing(node)
        node.children.each do |kid |
          process(kid) if kid.is_a?(AST::Node)
        end
      end

    end
  end
end

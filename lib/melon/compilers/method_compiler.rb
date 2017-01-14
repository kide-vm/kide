module Melon
  module Compilers

    class MethodCompiler < AST::Processor

      def initialize( ruby_method )
        @ruby_method
      end

      def handler_missing(node)
        raise "No handler for #{node}"
      end

    end
  end
end

module Melon
  module Compilers

    class Normalizer < AST::Processor

      def initialize( ruby_method )
        @ruby_method
      end

    end
  end
end

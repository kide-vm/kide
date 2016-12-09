module Typed
  module Tree
    class IntegerExpression < Expression
      attr_accessor :value
      def initialize(value)
        @value = value
      end
    end
    class FloatExpression < Expression
      attr_accessor :value
      def initialize(value)
        @value = value
      end
    end
    class TrueExpression < Expression
    end
    class FalseExpression < Expression
    end
    class NilExpression < Expression
    end
    class StringExpression < Expression
      attr_accessor :value
      def initialize(value)
        @value = value
      end
    end
    class NameExpression < Expression
      attr_accessor :value
      alias :name :value
      def initialize(value)
        @value = value
      end
    end
    class ClassExpression < Expression
      attr_accessor :value
      def initialize(value)
        @value = value
      end
    end
  end
end

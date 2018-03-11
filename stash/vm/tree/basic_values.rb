module Vm
  module Tree
    class IntegerExpression < Expression
      include ValuePrinter
      attr_accessor :value
      def initialize(value)
        @value = value
      end
    end
    class FloatExpression < Expression
      include ValuePrinter
      attr_accessor :value
      def initialize(value)
        @value = value
      end
    end
    class TrueExpression < Expression
      def to_s
        "true"
      end
    end
    class FalseExpression < Expression
      def to_s
        "false"
      end
    end
    class NilExpression < Expression
      def to_s
        "nil"
      end
    end
    class StringExpression < Expression
      include ValuePrinter
      attr_accessor :value
      def initialize(value)
        @value = value
      end
    end

    class NameExpression < Expression
      include ValuePrinter
      attr_accessor :value
      alias :name :value
      def initialize(value)
        @value = value
      end
    end

    class  LocalName < NameExpression
    end
    class  ArgumentName < NameExpression
    end
    class  InstanceName < NameExpression
    end
    class  KnownName < NameExpression
    end

    class ClassExpression < Expression
      include ValuePrinter
      attr_accessor :value
      def initialize(value)
        @value = value
      end
    end
  end
end

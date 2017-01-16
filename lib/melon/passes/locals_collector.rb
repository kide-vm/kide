module Melon
  module Passes
    class LocalsCollector < TotalProcessor

      def initialize
        @locals = {}
      end

      def collect(statement)
        process statement
        @locals
      end

      def on_lvasgn statement
        add_local( statement )
      end

      def add_local(statement)
        var = statement.children[0]
        @locals[var] = :Object #not really used right now
      end

    end
  end
end

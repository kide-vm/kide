require_relative "../helper"

module Risc
  module Builtin
    class BuiltinTest < MiniTest::Test
      include Ticker
      def setup
        @string_input = as_main(main)
        super
      end
    end
  end
end

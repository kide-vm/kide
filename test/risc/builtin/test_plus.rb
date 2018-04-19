require_relative "helper"

module Risc
  module Builtin
    class PlusTest < BuiltinTest

      def main
        "return 5 + 5"
      end
      def test_add
        #show_main_ticks # get output of what is
        run_all
        assert_equal Parfait::Integer , get_return.class
        assert_equal 10 , get_return.value
      end

    end
  end
end

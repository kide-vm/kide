require_relative "helper"

module Mom
  module Builtin
    class TestObjectMissingRisc < BootTest
      def setup
        @method = get_compiler("Object",:missing)
      end
      def test_mom_length
        assert_equal :method_missing , @method.callable.name
        assert_equal 7 , @method.mom_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 15 , @method.to_risc.risc_instructions.length
      end
    end
  end
end

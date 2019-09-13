require_relative "helper"

module Mom
  module Builtin
    class TestWordSetRisc < BootTest
      def setup
        super
        @method = get_compiler("Word",:set)
      end
      def test_mom_length
        assert_equal :set_internal_byte , @method.callable.name
        assert_equal 5 , @method.mom_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 17 , @method.to_risc.risc_instructions.length
      end
    end
  end
end

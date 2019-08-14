require_relative "helper"

module Mom
  module Builtin
    class TestWordSetRisc < BootTest
      def setup
        super
        @method = get_compiler(:set_internal_byte)
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 22 , @method.to_risc.risc_instructions.length
      end
    end
  end
end

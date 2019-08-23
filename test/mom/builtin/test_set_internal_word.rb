require_relative "helper"

module Mom
  module Builtin
    class TestWordSetRisc < BootTest
      def setup
        super
        @method = get_object_compiler(:set_internal_word)
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 16 , @method.to_risc.risc_instructions.length
      end
    end
  end
end

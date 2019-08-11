require_relative "helper"

module Risc
  module Builtin
    class TestObjectFunction1 < BootTest
      def setup
        super
        @method = get_compiler(:get_internal_word)
      end
      def test_has_get_internal
        assert_equal Mom::MethodCompiler , @method.class
      end
      def test_mom_length
        assert_equal 5 , @method.mom_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 20 , @method.to_risc.risc_instructions.length
      end
    end
  end
end

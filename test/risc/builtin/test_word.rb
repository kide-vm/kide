require_relative "helper"

module Risc
  module Builtin
    class TestWordPut < BootTest
      def setup
        super
        @method = get_compiler(:putstring)
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
        assert_equal 50 , @method.to_risc.risc_instructions.length
      end
    end
    class TestWordGet < BootTest
      def setup
        super
        @method = get_compiler(:get_internal_byte)
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
        assert_equal 48 , @method.to_risc.risc_instructions.length
      end
    end
    class TestWordSet < BootTest
      def setup
        super
        @method = get_compiler(:set_internal_byte)
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
        assert_equal 22 , @method.to_risc.risc_instructions.length
      end
    end
  end
end

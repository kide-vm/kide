require_relative "helper"

module Risc
  module Builtin
    class TestObjectFunctionGet < BootTest
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
    class TestObjectFunctionSet < BootTest
      def setup
        super
        @method = get_compiler(:set_internal_word)
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
        assert_equal 21 , @method.to_risc.risc_instructions.length
      end
    end
    class TestObjectFunctionMissing < BootTest
      def setup
        super
        @method = get_compiler(:method_missing)
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
    class TestObjectFunctionExit < BootTest
      def setup
        super
        @method = get_compiler(:exit)
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
        assert_equal 46 , @method.to_risc.risc_instructions.length
      end
    end
    class TestObjectFunctionInit < BootTest
      def setup
        super
        @method = get_compiler(:__init__)
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
  end
end

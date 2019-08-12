require_relative "helper"

module Risc
  module Builtin
    class TestIntDiv4 < BootTest
      def setup
        super
        @method = get_compiler(:div4)
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
        assert_equal 47 , @method.to_risc.risc_instructions.length
      end
    end
    class TestIntDiv10 < BootTest
      def setup
        super
        @method = get_compiler(:div10)
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
        assert_equal 76 , @method.to_risc.risc_instructions.length
      end
    end
    class TestIntComp1 < BootTest
      def setup
        super
        @method = get_compiler(:<)
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
        assert_equal 27 , @method.to_risc.risc_instructions.length
      end
    end
    class TestIntComp2 < BootTest
      def setup
        super
        @method = get_compiler(:>=)
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
        assert_equal 27 , @method.to_risc.risc_instructions.length
      end
    end
  end
end

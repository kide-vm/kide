require_relative "helper"

module Mom
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
    end
    class TestIntOperators < BootTest
      def setup
        super
      end
      def each_method &block
        Risc.operators.each do |name|
          method = get_compiler(name)
          block.yield(method)
        end
      end
      def test_has_get_internal
        each_method do |method|
          assert_equal Mom::MethodCompiler , method.class
          assert_equal 5 , method.mom_instructions.length
        end
      end
    end
  end
end

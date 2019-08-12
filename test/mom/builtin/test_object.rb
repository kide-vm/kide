require_relative "helper"

module Mom
  module Builtin
    class TestObjectGet < BootTest
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
    end
    class TestObjectSet < BootTest
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
    end
    class TestObjectMissing < BootTest
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
    end
    class TestObjectExit < BootTest
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
    end
    class TestObjectInit < BootTest
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
    end
  end
end

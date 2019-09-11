require_relative "helper"

module Mom
  module Builtin
    class TestObjectGet < BootTest
      def setup
        super
        @method = get_object_compiler(:get_internal_word)
      end
      def test_has_get_internal
        assert_equal Mom::MethodCompiler , @method.class
      end
      def test_mom_length
        assert_equal 5 , @method.mom_instructions.length
      end
      def test_return
        assert_equal ReturnSequence , @method.mom_instructions.next(3).class
      end
    end
    class TestObjectSet < BootTest
      def setup
        super
        @method = get_object_compiler(:set_internal_word)
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
        @method = get_object_compiler(:_method_missing)
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
        @method = get_object_compiler(:exit)
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
        @method = get_object_compiler(:__init__)
      end
      def test_has_get_internal
        assert_equal Mom::MethodCompiler , @method.class
      end
      def test_mom_length
        assert_equal 2 , @method.mom_instructions.length
      end
    end
  end
end

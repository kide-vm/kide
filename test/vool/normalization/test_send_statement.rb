require_relative "helper"

module Vool
  module Norm

    class TestSendSimple < NormTest
      def test_simple
        lst = normalize("foo")
        assert_equal SendStatement , lst.class
      end
      def test_constant_args
        lst = normalize("foo(1,2)")
        assert_equal SendStatement , lst.class
      end
    end
    class TestSendSend < NormTest
      def setup
        super
        @stm = normalize("foo(1 - 2)")
      end
      def test_many
        assert_equal Statements , @stm.class
      end
      def test_assignment
        assert_equal LocalAssignment , @stm.first.class
      end
      def test_name
        assert @stm.first.name.to_s.start_with?("tmp_") , @stm.first.name
      end
      def test_assigned
        assert_equal SendStatement , @stm.first.value.class
      end
    end
  end
end

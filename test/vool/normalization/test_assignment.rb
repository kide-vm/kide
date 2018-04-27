require_relative "helper"

module Vool
  module Norm

    class TestAssignSend < NormTest
      def setup
        super
        @stm = normalize("a = foo(1 - 2)")
      end
      def test_many
        assert_equal Statements , @stm.class
      end
      def test_assignment
        assert_equal LocalAssignment , @stm.first.class
      end
      def test_assignment_value
        assert_equal SendStatement , @stm.first.value.class
      end
      def test_assignment_method
        assert_equal :- , @stm.first.value.name
      end
      def test_length
        assert_equal 2 , @stm.length
      end
      def test_name
        assert @stm.first.name.to_s.start_with?("tmp_") , @stm.first.name
      end
      def test_assignment2
        assert_equal LocalAssignment , @stm.last.class
      end
      def test_name
        assert_equal :a , @stm.last.name
      end
      def test_assignment_method2
        assert_equal :foo , @stm.last.value.name
      end

    end

  end
end

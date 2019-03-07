require_relative "helper"

module Ruby
  class TestClassStatementTransform < MiniTest::Test
    include AttributeTests

    def attr_def
      "attr :page"
    end

    def test_method_len
      assert_equal 2 , @vool.body.length , "setter, getter"
    end
    def test_setter
      assert_equal Vool::MethodStatement , setter.class
    end
    def test_setter_assign
      assert_equal Vool::Statements , setter.body.class
      assert_equal Vool::IvarAssignment , setter.body.first.class
    end
    def test_setter_return
      assert_equal Vool::Statements , setter.body.class
      assert_equal Vool::ReturnStatement , setter.body.last.class
    end
    def test_setter_name
      assert_equal :page= , setter.name
    end
    def test_setter_args
      assert_equal [:val] , setter.args
    end
  end
  class TestClassStatementTransformReader < MiniTest::Test
    include AttributeTests

    def attr_def
      "attr_reader :page"
    end
    def test_method_len
      assert_equal 1 , @vool.body.length , "setter, getter"
    end

  end
end

require_relative "helper"

module Ruby
  class TestClassStatementTransform < MiniTest::Test
    include AttributeTests

    def attr_def
      "attr :page"
    end

    def test_class
      assert_equal Vool::ClassStatement , @vool.class
    end
    def test_body
      assert_equal Vool::Statements , @vool.body.class
    end
    def test_method_len
      assert_equal 2 , @vool.body.length , "setter, getter"
    end
    def test_getter
      assert_equal Vool::MethodStatement , getter.class
    end
    def test_getter_return
      assert_equal Vool::ReturnStatement , getter.body.class
    end
    def test_getter_name
      assert_equal :page , getter.name
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

end

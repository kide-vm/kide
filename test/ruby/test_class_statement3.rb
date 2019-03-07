require_relative "helper"

module Ruby
  class TestClassStatementTransformList < MiniTest::Test
    include AttributeTests

    def attr_def
      "attr :page , :size"
    end
    def test_method_len
      assert_equal 4 , @vool.body.length , "2 setters, 2 getters"
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
      assert_equal :size= , setter.name
    end
    def test_setter_args
      assert_equal [:val] , setter.args
    end
  end

end

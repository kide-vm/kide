require_relative "helper"


class TestBasic < MiniTest::Test
  include ExpressionHelper
  include AST::Sexp

  def setup
    Register.machine.boot
    @output = Register::RegisterValue
  end

  def test_number
    @input    = s(:int , 42)
    assert_equal 42 , check.value
  end

  def test_true
    @input    = s(:true)
    check
  end
  def test_false
    @input    = s(:false)
    check
  end
  def test_nil
    @input    = s(:nil)
    check
  end
  def test_self
    @input    = s(:name, :self)
    check
  end
  def test_string
    @input    = s(:string , "hello")
    check
  end

end

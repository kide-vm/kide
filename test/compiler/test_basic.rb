require_relative "compiler_helper"


class TestBasic < MiniTest::Test
  include CompilerHelper

  def setup
    @root = :basic_type
    @output = Register::RegisterValue
  end

  def test_number
    @string_input    = '42 '
    check
  end

  def test_true
    @string_input    = 'true'
    check
  end
  def test_false
    @string_input    = 'false '
    check
  end
  def test_nil
    @string_input    = 'nil '
    check
  end

  def test_var
    @string_input    = 'int foo '
    @root = :field_def
    @output = AST::Node
    check
  end

  def test_self
    @string_input    = 'self '
    @output = Virtual::Self
    check
  end

  def test_string
    @string_input    = "\"hello\""
    check
  end

end

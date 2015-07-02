require_relative "virtual_helper"

class TestBasic < MiniTest::Test
  include VirtualHelper

  def test_number
    @string_input    = '42 '
    @output = "- Virtual::Return(:type => Virtual::Integer, :value => 42)"
    check
  end

  def test_true
    @string_input    = 'true '
    @output = "- Virtual::Return(:type => Virtual::Reference, :value => true)"
    check
  end
  def test_false
    @string_input    = 'false '
    @output = "- Virtual::Return(:type => Virtual::Reference, :value => false)"
    check
  end
  def test_nil
    @string_input    = 'nil '
    @output = "- Virtual::Return(:type => Virtual::Reference)"
    check
  end

  def test_name
    @string_input    = 'foo '
    @output = "- Virtual::Return(:type => Virtual::Unknown)"
    check
  end

  def test_self
    @string_input    = 'self '
    @output = "- Virtual::Self(:type => Virtual::Reference())"
    check
  end

  def test_instance_variable
    @string_input    = '@foo_bar '
    @output = "- Virtual::Return(:type => Virtual::Unknown)"
    check
  end

  def pest_module_name
    @string_input    = 'FooBar '
    @output = ""
    check
  end

  def test_string
    @string_input    = "\"hello\""
    @output = "- Virtual::Return(:type => Virtual::Reference, :value => :hello)"
    check
  end

end

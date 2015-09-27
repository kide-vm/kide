require_relative "compiler_helper"


class TestBasic < MiniTest::Test
  def check
    expressions = Virtual.machine.boot.compile_main @string_input
    if( expressions.first.is_a? Virtual::Self )
      expressions.first.type.instance_variable_set :@of_class , nil
    end
    is = Sof.write(expressions)
    #puts is
    assert_equal @output , is
  end

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
    @output = "- Virtual::Return(:type => :int)"
    check
  end

  def test_self
    @string_input    = 'self '
    @output = "- Virtual::Self(:type => Virtual::Reference())"
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

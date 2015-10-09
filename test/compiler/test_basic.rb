require_relative "compiler_helper"


class TestBasic < MiniTest::Test
  def check
    input =  <<HERE
class Object
  int main()
  #{@string_input}
  end
end
HERE

    statements = Virtual.machine.boot.parse_and_compile input
    if( statements.first.is_a? Virtual::Self )
      statements.first.type.instance_variable_set :@of_class , nil
    end
    is = Sof.write(statements)
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

  def test_var
    @string_input    = 'int foo '
    @output = "- Virtual::Return(:type => :int)"
    check
  end

  def test_self
    @string_input    = 'self '
    @output = "- Virtual::Self(:type => Virtual::Reference())"
    check
  end

  def test_string
    @string_input    = "\"hello\""
    @output = "- Virtual::Return(:type => Virtual::Reference, :value => :hello)"
    check
  end

end

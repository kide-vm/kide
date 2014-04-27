require_relative 'helper'

class ParserTest < MiniTest::Test

  def setup
    @parser = Parser::Composed.new
  end

  def check
    is = @parser.parse(@input)
    assert is
    assert_equal @expected , is
  end
  def test_number
    @input    = '42 '
    @expected = {:integer => '42'}
    @parser = @parser.integer
    check
  end

  def test_name
    @input    = 'foo '
    @expected = {:name => 'foo'}
    @parser = @parser.name
    check
  end

  def test_argument_list
    @input    = '(42, foo)'
    @expected = {:argument_list => [{:argument => {:integer => '42'}},
                          {:argument => {:name   => 'foo'}}]}
    @parser = @parser.argument_list
    check
  end

  def test_function_call
    @input = 'baz(42, foo)'
    @expected = {:function_call => {:name => 'baz' },
                :argument_list    => [{:argument => {:integer => '42'}},
                             {:argument => {:name => 'foo'}}]}

    @parser = @parser.function_call
    check
  end

  def test_conditional
    @input = <<HERE
if (0) {
  42
} else {
  667
}
HERE
    @expected = {:cond     => {:integer => '0'},
                :if_true  => {:block => {:integer => '42'}},
                :if_false => {:block => {:integer => '667'}}}
    @parser = @parser.cond
    check
  end

  def test_function_definition
    @input    = <<HERE
def foo(x) {
  5
}
HERE
    @expected = {:function_definition   => {:name => 'foo'},
                :params => {:param => {:name => 'x'}},
                :block   => {:integer => '5'}}
    @parser = @parser.function_definition
    check
  end
end

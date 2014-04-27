require_relative 'helper'

class ParserTest < MiniTest::Test

  def setup
    @parser = Parser::Parser.new
  end

  def check
    is = @parser.parse(@@input)
    assert is
    assert_equal @expected , is
  end
  def test_number
    @input    = '42 '
    @expected = {:number => '42'}
    @parser = @parser.number
  end

  def test_name
    @input    = 'foo '
    @expected = {:name => 'foo'}
    @parser = @parser.name
  end

  def test_argument_list
    @input    = '(42, foo)'
    @expected = {:args => [{:arg => {:number => '42'}},
                          {:arg => {:name   => 'foo'}}]}
    @parser = @parser.args
  end

  def test_function_call
    @input = 'baz(42, foo)'
    @expected = {:funcall => {:name => 'baz' },
                :args    => [{:arg => {:number => '42'}},
                             {:arg => {:name => 'foo'}}]}

    @parser = @parser.funcall
  end

  def test_conditional
    @input = <<HERE
if (0) {
  42
} else {
  667
}
HERE
    @expected = {:cond     => {:number => '0'},
                :if_true  => {:body => {:number => '42'}},
                :if_false => {:body => {:number => '667'}}}
    @parser = @parser.cond
  end

  def test_function_definition
    @input    = <<HERE
function foo(x) {
  5
}
HERE
    @expected = {:func   => {:name => 'foo'},
                :params => {:param => {:name => 'x'}},
                :body   => {:number => '5'}}
    @parser = @parser.func
  end
end

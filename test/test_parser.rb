require_relative 'helper'

class ParserTest < MiniTest::Test

  def setup
    @parser = Parser::Composed.new
  end

  def check
    is = @parser.parse(@@input)
    assert is
    assert_equal @expected , is
  end
  def test_number
    @input    = '42 '
    @expected = {:integer => '42'}
    @parser = @parser.integer
  end

  def test_name
    @input    = 'foo '
    @expected = {:name => 'foo'}
    @parser = @parser.name
  end

  def test_argument_list
    @input    = '(42, foo)'
    @expected = {:args => [{:arg => {:integer => '42'}},
                          {:arg => {:name   => 'foo'}}]}
    @parser = @parser.args
  end

  def test_function_call
    @input = 'baz(42, foo)'
    @expected = {:funcall => {:name => 'baz' },
                :args    => [{:arg => {:integer => '42'}},
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
    @expected = {:cond     => {:integer => '0'},
                :if_true  => {:body => {:integer => '42'}},
                :if_false => {:body => {:integer => '667'}}}
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
                :body   => {:integer => '5'}}
    @parser = @parser.func
  end
end

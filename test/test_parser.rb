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

  def test_one_argument
    @input    = '(42)'
    @expected = {:argument_list => {:argument => {:integer => '42'}} }
    @parser = @parser.argument_list
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

  def test_expression_else
    @input    = <<HERE
4
5
else
HERE
    @expected = {:expressions=>[{:integer=>"4"}, {:integer=>"5"}]}
    
    @parser = @parser.expressions_else
    check
  end

  def test_expression_end
    @input    = <<HERE
5
name
call(4,6)
end
HERE
    @expected = {:expressions => [ { :integer => "5" }, 
                  { :name => "name" }, 
                  { :function_call => { :name => "call" } , 
                    :argument_list => [ {:argument => { :integer => "4" } } , 
                                        {:argument => { :integer => "6" } } ] } ]}
    @parser = @parser.expressions_end
    check
  end

  def test_conditional
    @input = <<HERE
if (0) 
  42
else
  667
end
HERE
    @expected = { :conditional => { :integer => "0"}, 
                  :if_true => {  :expressions => [ { :integer => "42" } ] } , 
                  :if_false => { :expressions => [ { :integer => "667" } ] } }
    @parser = @parser.conditional
    check
  end
  
  def test_function_definition
    @input    = <<HERE
def foo(x) 
  5
end
HERE
    @expected = {:function_definition   => {:name => 'foo'},
                :parmeter_list => {:parmeter => {:name => 'x'}},
                :expressions   => [{:integer => '5'}]}
    @parser = @parser.function_definition
    check
  end
end

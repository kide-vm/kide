require_relative 'helper'

# Some sanity is emerging in the testing of parsers 
#     (Parsers are fiddly in respect to space and order, small changes may and do have unexpected effects)

# For any functionality that we want to work (ie test), there are actually three tests, with the _same_ name
# One in each of the parser/transform/ast classes
# Parser test that the parser parses and thet the output is correct. Rules are named and and boil down to 
#        hashes and arrays with lots of symbols for the names the rules (actually the reults) were given
# Transform test really just test the tranformation. They basically take the output of the parse
#         and check that correct Ast classes are produced
# Ast   tests both steps in one. Ie string input to ast classes output

# All threee classes are layed out quite similarly in that they use a check method and 
# each test assigns @string_input and @parse_output which the check methods then checks
# The check methods have a pust in it (to be left) which is very handy for checking
# also the output of parser.check can actually be used as the input of transform

# Repeat: For every test in parser, there should beone in transform and ast
#                                  The test in transform should use the output of parser as input
#                                  The test in ast should expect the same result as transform

class ParserTest < MiniTest::Test

  def setup
    @parser = Parser::Composed.new
  end

  def check
    is = @parser.parse(@string_input)
    #puts is.inspect
    assert_equal @parse_output , is
  end

  def test_expression_else
    @string_input    = <<HERE
4
5
else
HERE
    @parse_output = {:expressions=>[{:integer=>"4"}, {:integer=>"5"}]}
    
    @parser = @parser.expressions_else
    check
  end

  def test_expression_end
    @string_input    = <<HERE
5
name
call(4,6)
end
HERE
    @parse_output = {:expressions => [ { :integer => "5" }, 
                  { :name => "name" }, 
                  { :function_call => { :name => "call" } , 
                    :argument_list => [ {:argument => { :integer => "4" } } , 
                                        {:argument => { :integer => "6" } } ] } ]}
    @parser = @parser.expressions_end
    check
  end

  def test_conditional
    @string_input = <<HERE
if (0) 
  42
else
  667
end
HERE
    @parse_output = { :conditional => { :integer => "0"}, 
                  :if_true => {  :expressions => [ { :integer => "42" } ] } , 
                  :if_false => { :expressions => [ { :integer => "667" } ] } }
    @parser = @parser.conditional
    check
  end
  
  def test_function_definition
    @string_input    = <<HERE
def foo(x) 
  5
end
HERE
    @parse_output = {:function_definition   => {:name => 'foo'},
                :parmeter_list => {:parmeter => {:name => 'x'}},
                :expressions   => [{:integer => '5'}]}
    @parser = @parser.function_definition
    check
  end

  def test_function_assignment
    @string_input    = <<HERE
def foo(x) 
 abba = 5 
end
HERE
    @parse_output = { :function_definition => { :name => "foo" } , 
                  :parmeter_list => { :parmeter => { :name => "x" } }, 
                  :expressions => [ { :asignee => { :name => "abba" }, :asigned => { :integer => "5" } } ]
                }
    @parser = @parser.function_definition
    check
  end

  def test_assignment
    @string_input    = "a = 5"
    @parse_output = { :asignee => { :name=>"a" } , :asigned => { :integer => "5" } }
    @parser = @parser.assignment
    check
  end

end

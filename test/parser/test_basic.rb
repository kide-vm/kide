require_relative "helper"

class TestBasic < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
    
  def test_number
    @string_input    = '42 '
    @parse_output = {:integer => '42'}
    @transform_output = Parser::IntegerExpression.new(42)
    @parser = @parser.integer
  end

  def test_name
    @string_input    = 'foo '
    @parse_output = {:name => 'foo'}
    @transform_output = Parser::NameExpression.new('foo')
    @parser = @parser.name
  end

  def test_string
    @string_input    = <<HERE
"hello" 
HERE
    @parse_output =  {:string=>"hello"}
    @transform_output =  Parser::StringExpression.new('hello')
    @parser = @parser.string
  end

  def test_assignment
    @string_input    = "a = 5"
    @parse_output = { :asignee => { :name=>"a" } , :asigned => { :integer => "5" } }
    @transform_output = Parser::AssignmentExpression.new("a", Parser::IntegerExpression.new(5) )
    @parser = @parser.assignment
  end

end
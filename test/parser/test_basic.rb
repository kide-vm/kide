require_relative "helper"

class TestBasic < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
    
  def test_number
    @string_input    = '42 '
    @parse_output = {:integer => '42'}
    @transform_output = Ast::IntegerExpression.new(42)
    @parser = @parser.integer
  end

  def test_name
    @string_input    = 'foo '
    @parse_output = {:name => 'foo'}
    @transform_output = Ast::NameExpression.new('foo')
    @parser = @parser.name
  end

  def test_comment
    @string_input    = '# i am a comment\n' #NEEDS the return, which is what delimits the comment
    @parse_output = {:comment => ' i am a comment'}
    @transform_output = @parse_output #dont transform
    @parser = @parser.comment
  end

  def test_string
    @string_input    = "\"hello\""
    @parse_output =  {:string=>"hello"}
    @transform_output =  Ast::StringExpression.new('hello')
    @parser = @parser.string
  end

  def test_string_escapes
    out = "hello  nyou"
    out[6] = '\\'
    @string_input    = "\"#{out}\""
    # puts will show that this is a string with a \n in it. 
    # but he who knows the ruby string rules well enough to do this in the input may win a beer at the ...
    # puts @string_input
    @parse_output =  {:string=>out} #chop quotes off
    @transform_output =  Ast::StringExpression.new(out)
    @parser = @parser.string
  end

  def test_assignment
    @string_input    = "a = 5"
    @parse_output = { :asignee => { :name=>"a" } , :asigned => { :integer => "5" } }
    @transform_output = Ast::AssignmentExpression.new("a", Ast::IntegerExpression.new(5) )
    @parser = @parser.assignment
  end

end
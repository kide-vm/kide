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
    out = "# i am a comment \n"
    @string_input    =  out.dup #NEEDS the return, which is what delimits the comment
    out = out[1..-2]
    @parse_output = {:comment => out}
    @transform_output = @parse_output #dont transform
    @parser = @parser.comment
  end

  def test_string
    @string_input    = "\"hello\""
    @parse_output =  {:string=>[{:char=>"h"}, {:char=>"e"}, {:char=>"l"}, {:char=>"l"}, {:char=>"o"}]}
    @transform_output =  Ast::StringExpression.new('hello')
    @parser = @parser.string
  end

  def test_string_escapes
    out = 'hello  \nyou'
    @string_input    = '"' + out + '"'
    @parse_output =  {:string=>[{:char=>"h"}, {:char=>"e"}, {:char=>"l"}, {:char=>"l"}, {:char=>"o"}, 
      {:char=>" "}, {:char=>" "}, {:esc=>"n"}, {:char=>"y"}, {:char=>"o"}, {:char=>"u"}]}
    @transform_output =  Ast::StringExpression.new(out)
    @parser = @parser.string
  end

end
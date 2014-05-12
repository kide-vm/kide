require_relative "helper"

class TestCompound < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
    
  def test_one_array
    @string_input    = '[42]'
    @parse_output = {:array=>[{:element=>{:integer=>"42"}}]}
    @transform_output =  Ast::ArrayExpression.new([Ast::IntegerExpression.new(42)])
    @parser = @parser.array
  end

  def test_array_list
    @string_input    = '[42, foo]'
    @parse_output = {:array=>[{:element=>{:integer=>"42"}}, {:element=>{:name=>"foo"}}]}
    @transform_output = Ast::ArrayExpression.new([Ast::IntegerExpression.new(42), Ast::NameExpression.new("foo")])
    @parser = @parser.array
  end

  def test_array_ops
    @string_input    = '[ 3 + 4 , foo(22) ]'
    @parse_output = {:array=>[{:element=>{:l=>{:integer=>"3"}, :o=>"+ ", :r=>{:integer=>"4"}}}, {:element=>{:function_call=>{:name=>"foo"}, :argument_list=>[{:argument=>{:integer=>"22"}}]}}]}
    @transform_output = Ast::ArrayExpression.new(
            [Ast::OperatorExpression.new("+", Ast::IntegerExpression.new(3),Ast::IntegerExpression.new(4)), 
              Ast::FuncallExpression.new("foo", [Ast::IntegerExpression.new(22)] )])
    @parser = @parser.array
  end

  def test_hash
    @string_input = '{ foo => 33 }'
    @parse_output = {:hash=>[{:hash_pair=>{:hash_key=>{:name=>"foo"}, :hash_value=>{:integer=>"33"}}}]}
    @transform_output = Ast::HashExpression.new([Ast::AssociationExpression.new(Ast::NameExpression.new("foo") , Ast::IntegerExpression.new(33))])
    @parser = @parser.hash
  end

  def test_hash_list
    @string_input = "{foo => 33 , bar => 42}"
    @parse_output = {:hash=>[{:hash_pair=>{:hash_key=>{:name=>"foo"}, :hash_value=>{:integer=>"33"}}}, {:hash_pair=>{:hash_key=>{:name=>"bar"}, :hash_value=>{:integer=>"42"}}}]}
    @transform_output = Ast::HashExpression.new([Ast::AssociationExpression.new(Ast::NameExpression.new("foo") , Ast::IntegerExpression.new(33)),Ast::AssociationExpression.new(Ast::NameExpression.new("bar") , Ast::IntegerExpression.new(42))])
    @parser = @parser.hash
  end

end
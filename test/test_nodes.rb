require_relative "helper"


#testing that parsing strings that we know to be correct returns the nodes we expect
# in a way the combination of test_parser and test_transform

class TestNodes < MiniTest::Test

  def setup
    @parser    = Parser::Parser.new
    @transform = Parser::Transform.new
  end
  
  def parse string
    syntax    = @parser.parse(string)
    tree      = @transform.apply(syntax)
    tree
  end
  
  def test_number
    tree = parse "42"
    assert_kind_of Vm::NumberExpression ,  tree
    assert_equal 42 , tree.value 
  end
  def test_args
    tree = parse "( 42 )"
    assert_kind_of Hash , tree
    assert_kind_of Vm::NumberExpression ,  tree[:args]
    assert_equal 42 , tree[:args].value 
  end
  def test_arg_list
    @parser = @parser.args
    tree = parse "(42, foo)"
    assert_instance_of Array , tree
    assert_equal 42 , tree.first.value 
    assert_equal "foo" , tree.last.name 
  end
end



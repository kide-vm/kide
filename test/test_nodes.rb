require_relative "helper"


#testing that parsing strings that we know to be correct returns the nodes we expect
# in a way the combination of test_parser and test_transform

class TestNodes < MiniTest::Test

  def setup
    @parser    = Parser::Composed.new
    @transform = Parser::Transform.new
  end
  
  def parse string
    syntax    = @parser.parse(string)
    tree      = @transform.apply(syntax)
    tree
  end
  
  def test_number
    tree = parse "42"
    assert_kind_of Vm::IntegerExpression ,  tree
    assert_equal 42 , tree.value 
  end
  def test_args
    tree = parse "( 42 )"
    assert_kind_of Hash , tree
    assert_kind_of Vm::IntegerExpression ,  tree[:argument_list]
    assert_equal 42 , tree[:argument_list].value 
  end
  def test_arg_list
    @parser = @parser.argument_list
    tree = parse "(42, foo)"
    assert_instance_of Array , tree
    assert_equal 42 , tree.first.value 
    assert_equal "foo" , tree.last.name 
  end
  def test_definition
    input    = <<HERE
def foo(x) {
  5
}
HERE
    @parser = @parser.function_definition
    tree = parse(input)
    assert_kind_of Vm::IntegerExpression ,  tree
  end
end



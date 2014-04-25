require_relative "helper"


#testing that parsing strings that we know to be correct returns the nodes we expect
# in a way the combination of test_parser and test_transform

class NodesCase < MiniTest::Test

  def setup
    @parser    = Vm::Parser.new
    @transform = Vm::Transform.new
  end
  
  def parse string
    syntax    = @parser.parse(string)
    tree      = @transform.apply(syntax)
    tree
  end
  
  def test_number
    tree = parse "42"
    assert tree.is_a? Vm::NumberExpression
    assert_equal 42 , tree.value 
  end
  def test_args
    tree = parse "( 42 )"
    assert tree.is_a? Hash
    assert tree[:args].is_a? Vm::NumberExpression
    assert_equal 42 , tree[:args].value 
  end
  def test_arg_list
    @parser = @parser.args
    tree = parse "(42, foo)"
    assert_equal Array , tree.class
    assert_equal 42 , tree.first.value 
    assert_equal "foo" , tree.last.name 
  end
end



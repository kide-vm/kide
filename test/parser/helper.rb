require_relative "../helper"

module ParserTest
  
  def setup
    @parser    = Parser::Composed.new
    @transform = Parser::Transform.new
  end

  def check_parse
    is = @parser.parse(@input)
    #puts is.inspect
    assert_equal @expected , is
  end

  def check_transform
    is = @transform.apply @input
    #puts is.transform
    assert_equal @expected , is
  end

  def check_ast
    syntax    = @parser.parse(@input)
    tree      = @transform.apply(syntax)
    # puts tree.inspect
    assert_equal @expected , tree
  end
  
end
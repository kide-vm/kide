require_relative "../helper"

module ParserTest
  
  def setup
    @parser    = Parser::Composed.new
    @transform = Parser::Transform.new
  end

  def check_parse
    is = @parser.parse(@input)
    #puts is.inspect
    assert_equal @parse_output , is
  end

  def check_transform
    is = @transform.apply @parse_output
    #puts is.transform
    assert_equal @transform_output , is
  end

  def check_ast
    syntax    = @parser.parse(@input)
    tree      = @transform.apply(syntax)
    # puts tree.inspect
    assert_equal @transform_output , tree
  end
    
end
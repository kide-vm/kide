require_relative "compiler_helper"


class CompilerTest < MiniTest::Test
  def setup
    Virtual.machine.boot
  end
  def check
    res = Virtual::Compiler.compile( @expression , Virtual.machine.space.get_main )
    assert res.is_a?(Virtual::Slot) , "compiler must compile to slot, not #{res.class}"
  end
  def true_ex
    Ast::TrueExpression.new
  end
  def name_ex
    Ast::NameExpression.new("name#{rand(100)}")
  end
  def list
     [true_ex]
  end
  def test_if_expression
    @expression = Ast::IfExpression.new( true_ex , list , list)
    check
  end
  def test_function_expression
    @expression = Ast::FunctionExpression.new( "name", [] , [true_ex] ,nil)
    check
  end
end

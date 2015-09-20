require_relative "compiler_helper"


class CompilerTest < MiniTest::Test
  include AST::Sexp
  def setup
    Virtual.machine.boot
  end
  def check
    res = Bosl::Compiler.compile( @expression , Virtual.machine.space.get_main )
    assert res.is_a?(Virtual::Slot) , "compiler must compile to slot, not #{res.inspect}"
  end
  def ttest_if_expression
#TODO review constant : all expressions return a slot 
    @expression = s(:if,
                    s(:condition,
                      s(:int,  0)),
                    s(:if_true,
                      s(:int,  42)),
                    s(:if_false,  nil))
    check
  end
  def test_function_expression
    @expression =   s(:function, :int, s(:name, :foo),
                        s(:parameters, s(:parameter, :ref, :x)),
                        s(:expressions, s(:int, 5)))
    check
  end
end

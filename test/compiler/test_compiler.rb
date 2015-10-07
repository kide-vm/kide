require_relative "compiler_helper"


class CompilerTest < MiniTest::Test
  include AST::Sexp
  def setup
    Virtual.machine.boot
  end
  def check
    res = Bosl::Compiler.compile( @expression )
    assert res.is_a?(Virtual::Slot) , "compiler must compile to slot, not #{res.inspect}"
  end
  def test_function_expression
    @expression =    s(:class, :Foo,
                        s(:derives, :Object),
                          s(:expressions,
                            s(:function, :int, s(:name, :foo),
                              s(:parameters, s(:parameter, :ref, :x)),
                                s(:expressions, s(:int, 5)))))
    check
  end
end

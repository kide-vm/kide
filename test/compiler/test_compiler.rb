require_relative "compiler_helper"


class CompilerTest < MiniTest::Test
  include AST::Sexp
  def setup
    Virtual.machine.boot
  end
  def check
    res = Phisol::Compiler.compile( @statement )
    assert res.is_a?(Virtual::Slot) , "compiler must compile to slot, not #{res.inspect}"
  end
  def test_function_statement
    @statement =    s(:class, :Foo,
                        s(:derives, :Object),
                          s(:statements,
                            s(:function, :int, s(:name, :foo),
                              s(:parameters, s(:parameter, :ref, :x)),
                                s(:statements, s(:int, 5)))))
    check
  end
end

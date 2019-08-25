require_relative "helper"
module Mom
  class PlusEquals < Instruction
    attr_reader :a , :b
    def initialize(source , arg , b)
      super(source)
      @a = arg
      @b = b
    end
  end
end

module Vool
  class TestMacroMom < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_first_method( "X.plus_equals(arg,1)")
      @ins = @compiler.mom_instructions.next
    end

    def test_class_compiles
      assert_equal Mom::PlusEquals , @ins.class , @ins
    end
    def test_arg1
      assert_equal  Vool::LocalVariable , @ins.a.class
      assert_equal  :arg , @ins.a.name
    end
    def test_arg2
      assert_equal  Vool::IntegerConstant , @ins.b.class
      assert_equal  1 , @ins.b.value
    end
  end

end

require_relative "helper"
module SlotMachine
  class PlusEquals < Instruction
    attr_reader :a , :b
    def initialize(source , arg , b)
      super(source)
      @a = arg
      @b = b
    end
    def to_risc(compiler)
      Risc.label("some" , "thing")
    end
  end
end

module Vool
  class TestMacroSlotMachine < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_main( "X.plus_equals(arg,1)")
      @ins = @compiler.slot_instructions.next
    end

    def test_class_compiles
      assert_equal SlotMachine::PlusEquals , @ins.class , @ins
    end
    def test_arg1
      assert_equal  Vool::LocalVariable , @ins.a.class
      assert_equal  :arg , @ins.a.name
    end
    def test_arg2
      assert_equal  Vool::IntegerConstant , @ins.b.class
      assert_equal  1 , @ins.b.value
    end
    def test_to_risc
      comp = @compiler.to_risc
      assert_equal Risc::MethodCompiler , comp.class
      assert_equal :main , comp.callable.name
    end
  end
end

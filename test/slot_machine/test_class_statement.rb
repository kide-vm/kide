
require_relative "helper"

module Vool
  class TestClassStatementSlotMachine < MiniTest::Test
    include SlotMachineCompile

    def setup
      @ret = compile_slot( as_main("return 1"))
    end

    def test_return_class
      assert_equal SlotMachine::SlotCollection , @ret.class
    end
    def test_has_compilers
      assert_equal SlotMachine::MethodCompiler , @ret.method_compilers.class
    end

    def test_constant
      assert @ret.method_compilers.add_constant( Parfait::Integer.new(5) )
    end

  end
end

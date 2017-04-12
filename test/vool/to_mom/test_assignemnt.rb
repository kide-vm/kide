require_relative "helper"

module Vool
  class TestAssignemnt < MiniTest::Test
    include CompilerHelper

    def setup
      Risc.machine.boot
    end

    def compile_first_method input
      lst = VoolCompiler.compile as_main( input )
      assert_equal Parfait::Class , lst.clazz.class , input
      method = lst.clazz.get_method(:main)
      assert method
      lst.to_mom( nil ).first
    end

    def test_class_compiles
      meth = compile_first_method( "a = 5")
      assert_equal Mom::SlotLoad , meth.first.class , meth
    end
  end
end

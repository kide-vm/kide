require_relative "helper"
module Risc
  class FakeCallableCompiler < CallableCompiler
    def initialize(a,c)
      super(a,c)
    end
    def source_name
      "luke"
    end
  end
  class TestCallableCompiler < MiniTest::Test

    def setup
      Parfait.boot!({})
      label = SlotMachine::Label.new("hi","ho")
      @compiler = FakeCallableCompiler.new(FakeCallable.new  , label)
    end
    def test_ok
      assert @compiler
    end
    def test_current
      assert @compiler.current
    end
    def test_current_label
      assert_equal Label , @compiler.current.class
      assert_equal "ho" , @compiler.current.name
    end
    def test_slot
      assert @compiler.risc_instructions
    end
    def test_const
      assert_equal Array , @compiler.constants.class
    end
  end
end

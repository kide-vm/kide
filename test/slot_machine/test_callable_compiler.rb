require_relative "helper"
module SlotMachine
  # need to derive, to overwrite source_name
  class FakeCallableCompiler < CallableCompiler
    def source_name
      "luke"
    end
  end
  class TestCallableCompiler < MiniTest::Test

    def setup
      @compiler = FakeCallableCompiler.new(Risc::FakeCallable.new)
    end
    def test_ok
      assert @compiler
    end
    def test_current
      assert @compiler.current
    end
    def test_current_label
      assert_equal Label , @compiler.current.class
      assert_equal @compiler.source_name , @compiler.current.name
    end
    def test_slot
      assert @compiler.slot_instructions
    end
    def test_const
      assert_equal Array , @compiler.constants.class
    end
  end
end

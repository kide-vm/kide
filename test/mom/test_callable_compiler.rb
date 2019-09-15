require_relative "helper"
module Mom
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
    def test_mom
      assert @compiler.mom_instructions
    end
    def test_const
      assert_equal Array , @compiler.constants.class
    end
  end
end

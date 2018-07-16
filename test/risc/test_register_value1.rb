require_relative "../helper"

module Risc
  class TestRegisterValue < MiniTest::Test

    def setup
      Parfait.boot!
      @r0 = RegisterValue.new(:r0 , :Message)
      @r1 = RegisterValue.new(:r1 , :Space)
      @compiler = FakeCompiler.new
    end

    def test_resolves_index_ok
      assert_equal 6 , @r0.resolve_index(:caller)
    end
    def test_resolves_index_fail
      assert_raises {@r0.resolve_index(:something)}
    end
    def test_get_new_left_0
      assert_equal RegisterValue , @r0.get_new_left(:caller , @compiler).class
    end
    def test_get_new_left_0_reg
      assert_equal :r1 , @r0.get_new_left(:caller , @compiler).symbol
    end
    def test_get_new_left_1
      assert_equal RegisterValue , @r0.get_new_left(:caller , @compiler).class
    end
    def test_get_new_left_1_reg
      assert_equal :r1 , @r0.get_new_left(:caller , @compiler).symbol
    end
  end
end

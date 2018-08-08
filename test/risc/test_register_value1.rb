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
    def test_reduce_int
      ins = @r0.reduce_int
      assert_equal SlotToReg , ins.class
      assert_equal Parfait::Integer.integer_index , ins.index
    end
    def test_get_new_left_0
      assert_equal RegisterValue , @r0.get_new_left(:caller , @compiler).class
    end
    def test_get_new_left_no_extra
      assert @r0.get_new_left(:caller , @compiler).extra.empty?
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
    def test_get_left_uses_extra
      @r1 = RegisterValue.new(:r1 , :Space , type_arguments: @r0.type)
      # works with nil as compiler, because extra is used
      assert_equal :Message , @r1.get_new_left(:arguments , nil).type.class_name
    end
  end
end

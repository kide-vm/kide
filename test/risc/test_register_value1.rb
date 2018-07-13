require_relative "../helper"

module Risc
  class FakeCompiler
    def resolve_type(name)
      Parfait.object_space.types.values.first
    end
    def use_reg(type)
      RegisterValue.new(:r1 , type)
    end
  end

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
    def test_revolve_new_type_0
      assert_equal "Message_Type",  @r0.resolve_new_type(:caller , @compiler).name
    end
    def test_revolve_new_type_1
      # returned by FakeCompiler , not real
      assert_equal "BinaryCode_Type", @r1.resolve_new_type(:receiver , @compiler).name
    end
    def test_get_new_left_0
      assert_equal RegisterValue , @r0.get_new_left(:caller , @compiler).class
    end
    def test_get_new_left_0_reg
      assert_equal :r1 , @r0.get_new_left(:caller , @compiler).symbol
    end
    def test_get_new_left_1
      assert_equal RegisterValue , @r1.get_new_left(:caller , @compiler).class
    end
    def test_get_new_left_1_reg
      assert_equal :r1 , @r1.get_new_left(:caller , @compiler).symbol
    end
  end
end

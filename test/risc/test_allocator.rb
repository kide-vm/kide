require_relative "../helper"

module Risc
  class TestAllocator < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @allocator = Allocator.new(Risc.test_compiler , Platform.for(:arm))
    end
    def tmp_reg
      Risc.tmp_reg(:Type)
    end
    def test_regs
      assert_equal Array , @allocator.regs.class
    end
    def test_empty
      assert @allocator.regs_empty?
    end
    def test_compiler
      assert_equal CallableCompiler , @allocator.compiler.class
      assert_equal :fake_name , @allocator.compiler.callable.name
    end
    def test_platform
      assert_equal Arm::ArmPlatform , @allocator.platform.class
    end
    def test_add_ok
      assert_equal Array, @allocator.add_reg(tmp_reg).class
    end
    def test_add_fail
      assert_raises{ @allocator.add_reg(1)}
    end
    def test_pop
      @allocator.add_reg(tmp_reg)
      assert_equal RegisterValue , @allocator.pop.class
    end
    def test_clear
      @allocator.clear_regs
      assert @allocator.regs_empty?
    end
  end
end

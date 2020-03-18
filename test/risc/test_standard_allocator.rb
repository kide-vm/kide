require_relative "../helper"

module Risc
  class TestStandardAllocator < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @allocator = StandardAllocator.new(Risc.test_compiler , Platform.for(:arm))
    end
    def tmp_reg
      Risc.tmp_reg(:Type)
    end
    def test_regs
      assert_equal Hash , @allocator.used_regs.class
    end
    def test_empty
      assert @allocator.used_regs_empty?
    end
    def test_reg_names
      assert_equal 16 , @allocator.reg_names.length
    end
    def test_compiler
      assert_equal CallableCompiler , @allocator.compiler.class
      assert_equal :fake_name , @allocator.compiler.callable.name
    end
    def test_platform
      assert_equal Arm::ArmPlatform , @allocator.platform.class
    end
    def test_add_ok
      assert_equal RegisterValue, @allocator.use_reg(tmp_reg).class
    end
    def test_add_fail
      assert_raises{ @allocator.use_reg(1)}
    end
    def test_release_reg
      @allocator.use_reg(tmp_reg)
      assert_equal RegisterValue , @allocator.release_reg(tmp_reg).class
    end
    def test_remove_symbol
      @allocator.use_reg(tmp_reg)
      assert_equal RegisterValue , @allocator.release_reg(tmp_reg.symbol).class
    end
    def test_clear
      @allocator.clear_used_regs
      assert @allocator.used_regs_empty?
    end
  end
end

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
    def test_reg_names
      assert_equal 13 , @allocator.reg_names.length
    end
    def test_compiler
      assert_equal CallableCompiler , @allocator.compiler.class
      assert_equal :fake_name , @allocator.compiler.callable.name
    end
    def test_platform
      assert_equal Arm::ArmPlatform , @allocator.platform.class
    end
    def test_allocate_runs
      assert_nil @allocator.allocate_regs
    end
    def test_live
      live = @allocator.walk_and_mark(@allocator.compiler.risc_instructions)
      assert_equal 0 , live.length
    end
    def test_add_ok
      assert_equal Symbol, @allocator.use_reg(:r1, :some).class
      assert @allocator.used_regs.include?(:r1)
    end
    def test_reverse_check
      assert_equal Symbol, @allocator.use_reg(:r1, :some).class
      assert_equal :r1 , @allocator.reverse_used(:some)
    end
    def test_add_fail
      assert_raises{ @allocator.use_reg(1)}
    end
    def test_release_reg
      @allocator.use_reg(:r1 , :some)
      assert  @allocator.used_regs.include?(:r1)
      assert_equal Symbol , @allocator.release_reg(tmp_reg).class
      assert  !@allocator.used_regs.include?(:r1)
    end
  end
end

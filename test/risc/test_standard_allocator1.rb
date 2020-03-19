require_relative "../helper"

module Risc
  class TestStandardAllocator1 < MiniTest::Test
    include SlotMachineCompile
    def setup
      coll = compile_slot( "class Space ; def main(); main{return 'Ho'};return 'Hi'; end; end;")
      @compiler = coll.to_risc.method_compilers
      @allocator = Platform.for(:arm).allocator(@compiler)
    end
    def test_main
      assert_equal :main , @compiler.callable.name
    end
    def test_allocate_runs
      assert_nil @allocator.allocate_regs
      assert_equal 10 , @allocator.used_regs.length
    end
    def test_live_length
      live = @allocator.walk_and_mark(@compiler.risc_instructions)
      assert_equal 10 , live.length
    end
  end
end

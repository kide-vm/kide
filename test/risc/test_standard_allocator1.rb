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
      assert @allocator.allocate_regs
    end
    def test_live_length
      live = @allocator.determine_liveness
      assert_equal 10 , live.length
    end
  end
end

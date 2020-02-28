require_relative "helper"

module SlotMachine
  class TestSlotLoad3 < MiniTest::Test
    include Parfait::MethodHelper

    def setup
      Parfait.boot!(Parfait.default_test_options)
      method = make_method
      compiler = Risc.test_compiler
      @cache_entry = Parfait::CacheEntry.new(method.frame_type, method)
      load = SlotLoad.new("test", [@cache_entry , :cached_type] , [:message, :type] )
      load.to_risc(compiler)
      @instructions = compiler.risc_instructions.next
    end
    def test_ins_next_class
      assert_equal Risc::SlotToReg ,   @instructions.class
      assert_equal Risc::LoadConstant, @instructions.next.class
    end

    def test_ins_next_class
      assert_equal Risc::RegToSlot ,   @instructions.next(2).class
      assert_equal NilClass ,   @instructions.next(3).class
    end
    def test_ins_load
      assert_equal :r3 , @instructions.next.register.symbol
      assert_equal Parfait::CacheEntry , @instructions.next.constant.class
    end

    def test_ins_next_reg
      assert_equal :r2 , @instructions.register.symbol
    end
    def test_ins_next_arr
      assert_equal :r0 , @instructions.array.symbol
    end
    def test_ins_next_index
      assert_equal 0 , @instructions.index
    end

    def test_ins_next_2_reg
      assert_equal :r2 , @instructions.next(2).register.symbol
    end
    def test_ins_next_2_arr
      assert_equal :r3 , @instructions.next(2).array.symbol
    end
    def test_ins_next_2_index
      assert_equal 1 , @instructions.next(2).index
    end

  end
end

require_relative "helper"

module Mom
  class TestSlotLoad3 < Parfait::ParfaitTest

    def setup
      super
      method = make_method
      @compiler = Risc::FakeCompiler.new
      @cache_entry = Parfait::CacheEntry.new(method.frame_type, method)
      load = SlotLoad.new("test", [@cache_entry , :cached_type] , [:message, :type] )
      load.to_risc(@compiler)
      @instructions = @compiler.instructions
    end
    def test_ins_next_class
      assert_equal Risc::SlotToReg ,   @instructions[0].class
      assert_equal Risc::LoadConstant, @instructions[1].class
    end

    def test_ins_next_class
      assert_equal Risc::RegToSlot ,   @instructions[2].class
      assert_equal NilClass ,   @instructions[3].class
    end
    def test_ins_load
      assert_equal :r1 , @instructions[1].register.symbol
      assert_equal Parfait::CacheEntry , @instructions[1].constant.class
    end

    def test_ins_next_reg
      assert_equal :r1 , @instructions[0].register.symbol
    end
    def test_ins_next_arr
      assert_equal :r0 , @instructions[0].array.symbol
    end
    def test_ins_next_index
      assert_equal 0 , @instructions[0].index
    end

    def test_ins_next_2_reg
      assert_equal :r1 , @instructions[2].register.symbol
    end
    def test_ins_next_2_arr
      assert_equal :r1 , @instructions[2].array.symbol
    end
    def test_ins_next_2_index
      assert_equal 1 , @instructions[2].index
    end

  end
end

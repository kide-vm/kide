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
    def test_ins
      assert_slot_to_reg @instructions , :message , 0 , "message.type"
    end
    def test_ins_next
      assert_load  @instructions.next , Parfait::CacheEntry , "id_"
    end
    def test_ins_next_2
      assert_reg_to_slot @instructions.next(2) , :"message.type" , "id_", 1
    end

  end
end

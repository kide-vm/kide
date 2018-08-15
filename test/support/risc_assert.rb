module Minitest
  module Assertions
    def assert_slot_to_reg( slot , array = nil, index = nil , register = nil)
      assert_equal Risc::SlotToReg , slot.class
      assert_equal( array , slot.array.symbol , "wrong source register") if array
      assert_equal( index , slot.index, "wrong source index") if index
      assert_equal( register , slot.register.symbol, "wrong destination") if register
    end
    def assert_reg_to_slot( slot , register = nil, array = nil, index = nil )
      assert_equal Risc::RegToSlot , slot.class
      assert_equal( register , slot.register.symbol, "wrong source register") if register
      assert_equal( array , slot.array.symbol, "wrong destination register") if array
      assert_equal( index , slot.index, "wrong destination index") if index
    end
    def assert_load(load , clazz = nil , register = nil)
      assert_equal Risc::LoadConstant , load.class
      assert_equal( clazz , load.constant.class) if clazz
      assert_equal( register , load.register.symbol, "wrong destination register") if register
    end
    def assert_transfer( transfer , from , to)
      assert_equal Risc::Transfer , transfer.class
      assert_equal from , transfer.from.symbol
      assert_equal to , transfer.to.symbol
    end
  end
end

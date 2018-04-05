module Risc
  module Assertions
    def assert_slot_to_reg( slot , array = nil, index = nil , register = nil)
      assert_equal SlotToReg , slot.class
      assert_equal( array , slot.array.symbol) if array
      assert_equal( index , slot.index) if index
      assert_equal( register , slot.register.symbol) if register
    end
    def assert_load(load , clazz = nil , register = nil)
      assert_equal LoadConstant , load.class
      assert_equal( clazz , load.constant.class) if clazz
      assert_equal( register , load.register.symbol) if register
    end
  end
end

module Minitest
  module Assertions
    def assert_tos string , object
      assert_equal string , object.to_s.gsub("\n",";").gsub(/\s+/," ").gsub("; ",";")
    end
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
    def assert_label( label , name )
      assert_equal Risc::Label , label.class
      if(name[-1] == "_")
        assert label.name.start_with?(name) , "Label does not start with #{name}:#{label.name}"
      else
        assert_equal name , label.name
      end
    end
    def assert_branch( branch , label_name )
      assert_equal Risc::Branch , branch.class
      assert_label branch.label , label_name
    end
    def assert_operator ins , op , left , right
      assert_equal Risc::OperatorInstruction , ins.class
      assert_equal op , ins.operator
      assert_equal left , ins.left.symbol
      assert_equal right , ins.right.symbol
    end
    def assert_zero ins , label
      assert_equal Risc::IsZero , ins.class
      assert_label ins.label , label
    end
    def assert_syscall ins , name
      assert_equal Risc::Syscall , ins.class
      assert_equal ins.name , name
    end

  end
end

module Minitest
  module Assertions
    def assert_tos string , object
      assert_equal string , object.to_s.gsub("\n",";").gsub(/\s+/," ").gsub("; ",";")
    end
    def assert_register( kind , pattern , register)
      return unless register
      if(pattern.is_a?(Symbol))
        assert_equal( pattern , register.symbol , "wrong #{kind} register:#{register}")
      else
        is_parts = pattern.split(".")
        reg_parts = register.symbol.to_s.split(".")
        assert_equal reg_parts.length , is_parts.length , "wrong dot length for #{pattern}"
        is_parts.each_with_index do |part , index|
          assert reg_parts[index].start_with?(part) , "wrong #{kind}, at:#{part} register:#{register}"
        end
      end
    end
    def assert_slot_to_reg( slot , array = nil, index = nil , register = nil)
      assert_equal Risc::SlotToReg , slot.class
      assert_register( :source , array , slot.array)
      assert_register( :destination , register , slot.register )
      assert_index( :source , slot , index)
    end
    def assert_reg_to_slot( slot , register = nil, array = nil, index = nil )
      assert_equal Risc::RegToSlot , slot.class
      assert_register( :source , register , slot.register )
      assert_register( :destination , array , slot.array)
      assert_index( :destination , slot , index)
    end
    def assert_index(kind , slot , index)
      return unless index
      if(slot.index.is_a?(Risc::RegisterValue))
        assert_equal( Symbol , index.class, "wrong #{kind} index class")
        assert_equal( index , slot.index.symbol, "wrong #{kind} index")
      else
        assert_equal( index , slot.index, "wrong #{kind} index")
      end
    end
    def assert_load(load , clazz = nil , register = nil)
      assert_equal Risc::LoadConstant , load.class
      assert_equal( clazz , load.constant.class) if clazz
      if register
        assert_register(:source , register , load.register)
      else
        raise "rewrite"
      end
    end
    def assert_transfer( transfer , from , to)
      assert_equal Risc::Transfer , transfer.class
      assert_register( :source , from , transfer.from )
      assert_register( :destination , to , transfer.to )
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
      assert_register :left , left , ins.left
      assert_register :right , right , ins.right
    end
    def assert_zero ins , label
      assert_equal Risc::IsNotZero , ins.class
      assert_label ins.label , label
    end
    def assert_not_zero ins , label
      assert_equal Risc::IsZero , ins.class
      assert_label ins.label , label
    end
    def assert_syscall ins , name
      assert_equal Risc::Syscall , ins.class
      assert_equal ins.name , name
    end
    def assert_minus ins , label
      assert_equal Risc::IsMinus , ins.class
      assert_label ins.label , label
    end
    def assert_data(ins , data)
      assert_equal Risc::LoadData , ins.class
      assert_equal data , ins.constant
    end
  end
end

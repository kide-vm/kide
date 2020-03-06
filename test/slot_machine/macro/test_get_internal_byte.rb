require_relative "helper"

module SlotMachine
  module Builtin
    class TestWordGetRisc < BootTest
      def setup
        super
        @method = get_compiler("Word",:get)
      end
      def test_slot_length
        assert_equal :get_internal_byte , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 41 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_all
        assert_slot_to_reg risc(23),:r0 , 2 , :r2
        assert_slot_to_reg risc(24),:r0 , 9 , :r3
        assert_slot_to_reg risc(25),:r3 , 2 , :r3

        assert_equal Risc::ByteToReg , risc(26).class
        assert_equal :r2 , risc(26).array.symbol
        assert_equal :r2 , risc(26).register.symbol
        assert_equal :r3 , risc(26).index.symbol


        assert_reg_to_slot risc(27) , :r2 , :r1 , 2
        assert_reg_to_slot risc(28) , :r1 , :r0 , 5
        assert_slot_to_reg risc(29),:r0 , 5 , :r2
        assert_reg_to_slot risc(30) , :r2 , :r0 , 5

        assert_branch risc(31) , "return_label"
        assert_label risc(32) , "return_label"
      end
      def test_return
        assert_return(32)
      end
    end
  end
end

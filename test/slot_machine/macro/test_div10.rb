require_relative "helper"

module SlotMachine
  module Builtin
    class TestIntDiv10Risc < BootTest
      def setup
        @method = get_compiler("Integer",:div10)
      end
      def test_slot_length
        assert_equal :div10 , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 69 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_return
        assert_return(61)
      end
      def test_all
        assert_slot_to_reg risc(23) , :r0 , 2 , :r2
        assert_slot_to_reg risc(24) , :r2 , 2 , :r2
        assert_transfer risc(25) , :r2 , :r3
        assert_transfer risc(26) , :r2 , :r4
        assert_data risc(27) , 1
        assert_operator risc(28) , :>> , :r3 , :r5
        assert_data risc(29) , 2
        assert_operator risc(30) , :>> , :r4 , :r5
        assert_operator risc(31) , :+ , :r4 , :r3
        assert_data risc(32) , 4
        assert_transfer risc(33) , :r4 , :r3
        assert_operator risc(34) , :>> , :r4 , :r3
        assert_operator risc(35) , :+ , :r4 , :r3
        assert_data risc(36) , 8
        assert_transfer risc(37) , :r4 , :r3
        assert_operator risc(38) , :>> , :r3 , :r5
        assert_operator risc(39) , :+ , :r4 , :r3
        assert_data risc(40) , 16
        assert_transfer risc(41) , :r4 , :r3
        assert_operator risc(42) , :>> , :r3 , :r5
        assert_operator risc(43) , :+ , :r4 , :r3
        assert_data risc(44) , 3
        assert_operator risc(45) , :>> , :r4 , :r5
        assert_data risc(46) , 10
        assert_transfer risc(47) , :r4 , :r3
        assert_operator risc(48) , :* , :r3 , :r5
        assert_operator risc(49) , :- , :r2 , :r3
        assert_transfer risc(50) , :r2 , :r3
        assert_data risc(51) , 6
        assert_operator risc(52) , :+ , :r3 , :r5
        assert_data risc(53) , 4
        assert_operator risc(54) , :>> , :r3 , :r5
        assert_operator risc(55) , :+ , :r4 , :r3
        assert_reg_to_slot risc(56) , :r4 , :r1 , 2
        assert_reg_to_slot risc(57) , :r1 , :r0 , 5
        assert_slot_to_reg risc(58),:r0 , 5 , :r2
        assert_reg_to_slot risc(59) , :r2 , :r0 , 5
        assert_branch risc(60) , "return_label"
      end
    end
  end
end

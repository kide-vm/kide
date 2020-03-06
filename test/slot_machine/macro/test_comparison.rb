require_relative "helper"

module SlotMachine
  module Builtin
    class TestIntComp1Risc < BootTest
      def setup
        @method = get_compiler("Integer",:lt)
      end
      def test_slot_length
        assert_equal :< , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 25 , @method.to_risc.risc_instructions.length
      end
      #TODO, check the actual instructions, at least by class
    end
    class TestIntComp2Risc < BootTest
      def setup
        @method = get_compiler("Integer",:ge)
      end
      def test_slot_length
        assert_equal :>= , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 24 , @method.to_risc.risc_instructions.length
      end
      def test_all
        assert_slot_to_reg risc(1),:r0 , 2 , :r1
        assert_slot_to_reg risc(2),:r1 , 2 , :r1
        assert_slot_to_reg risc(3),:r0 , 9 , :r2
        assert_slot_to_reg risc(4),:r2 , 2 , :r2
        assert_operator risc(5) , :- , :r1 , :r2
        assert_minus risc(6) , "false_label_"
        assert_zero risc(7) , "false_label_"
        assert_load risc(8) , Parfait::TrueClass
        assert_branch risc(9) , "merge_label_"
        assert_label risc(10) , "false_label_"
        assert_load risc(11) , Parfait::FalseClass
        assert_label risc(12) , "merge_label_"
        assert_reg_to_slot risc(13) , :r3 , :r0 , 5
        assert_slot_to_reg risc(14),:r0 , 5 , :r2
        assert_reg_to_slot risc(15) , :r2 , :r0 , 5
        assert_branch risc(16) , "return_label"
      end
      def test_return
        assert_return(17)
      end
    end
  end
end

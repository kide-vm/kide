require_relative "helper"

module SlotMachine
  module Builtin
    class TestIntOpPl < BootTest
      def setup
        @method = get_compiler("Integer",:and)
      end
      def test_slot_length
        assert_equal :& , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 42 , @method.to_risc.risc_instructions.length
      end
    end
    class TestIntOpMM < BootTest
      def setup
        @method = get_compiler("Integer",:or)
      end
      def test_slot_length
        assert_equal :| , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 42 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_all
        assert_slot_to_reg risc(23),:r0 , 2 , :r2
        assert_slot_to_reg risc(24),:r2 , 2 , :r2
        assert_slot_to_reg risc(25),:r0 , 9 , :r3
        assert_slot_to_reg risc(26),:r3 , 2 , :r3
        assert_operator risc(27) , :| , :r2 , :r3
        assert_reg_to_slot risc(28) , :r2  , :r1 , 2
        assert_reg_to_slot risc(29) , :r1  , :r0 , 5
        assert_slot_to_reg risc(30),:r0 , 5 , :r2
        assert_reg_to_slot risc(31) , :r2  , :r0 , 5
        assert_branch risc(32) , "return_label"
        assert_label risc(33) , "return_label"
      end
      def test_return
        assert_return(33)
      end
    end
  end
end

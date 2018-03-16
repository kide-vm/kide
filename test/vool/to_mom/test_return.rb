require_relative "helper"

module Vool
  class TestReturnMom < MiniTest::Test
    include MomCompile
    include Mom

    def setup
      Risc.machine.boot
      @inst = compile_first_method( "return 5")
    end

    def test_class_compiles
      assert_equal SlotLoad , @inst.class , @inst
    end
    def test_slot_is_set
      assert @inst.left
    end
    def test_two_instructions_are_returned
      assert_equal 2 ,  @inst.length
    end
    def test_second_is_return
      assert_equal ReturnSequence,  @inst.last.class
    end
    def test_slot_starts_at_message
      assert_equal :message , @inst.left.known_object
    end
    def test_slot_gets_return
      assert_equal :return_value , @inst.left.slots[0]
    end
    def test_slot_assigns_something
      assert @inst.right
    end
    def test_slot_assigns_int
      assert_equal Mom::IntegerConstant ,  @inst.right.class
    end
    def test_array
      check_array [SlotLoad,ReturnSequence] , @ins
    end
  end
  class TestReturnSendMom < MiniTest::Test
    include MomCompile
    include Mom

    def setup
      Risc.machine.boot
      @ins = compile_first_method( "return 5.mod4")
    end

    def test_return_is_last
      assert_equal ReturnSequence , @ins.last.class
    end
    def test_array
      check_array [MessageSetup,SlotLoad,ArgumentTransfer,SimpleCall,SlotLoad,SlotLoad,ReturnSequence] , @ins
    end
  end
end

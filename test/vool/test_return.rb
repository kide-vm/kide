require_relative "helper"

module Vool
  class TestReturnMom < MiniTest::Test
    include VoolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = compile_first_method( "return 5")
      @ins = @compiler.mom_instructions.next
    end

    def test_class_compiles
      assert_equal SlotLoad , @ins.class , @ins
    end
    def test_slot_is_set
      assert @ins.left
    end
    def test_two_instructions_are_returned
      assert_equal 5 ,  @ins.length
    end
    def test_slot_starts_at_message
      assert_equal :message , @ins.left.known_object
    end
    def test_slot_gets_return
      assert_equal :return_value , @ins.left.slots[0]
    end
    def test_slot_assigns_something
      assert @ins.right
    end
    def test_slot_assigns_int
      assert_equal Mom::IntegerConstant ,  @ins.right.known_object.class
    end
    def test_second_is_return
      assert_equal ReturnJump,  @ins.next(1).class
    end
    def test_array
      check_array [SlotLoad, ReturnJump, Label, ReturnSequence, Label], @ins
    end
  end
  class TestReturnSendMom < MiniTest::Test
    include VoolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = compile_first_method( "return 5.div4")
      @ins = @compiler.mom_instructions.next
    end

    def test_return_is_last
      assert_equal ReturnJump , @ins.next(4).class
    end
    def test_array
      check_array [MessageSetup, ArgumentTransfer, SimpleCall, SlotLoad, ReturnJump ,
                    Label, ReturnSequence, Label] , @ins
    end
  end
end

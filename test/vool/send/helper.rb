require_relative "../helper"

module Vool
  # relies on @ins and receiver_type method
  module SimpleSendHarness
    include VoolCompile
    include Mom

    def setup
      @compiler = compile_first_method( send_method )
      @ins = @compiler.mom_instructions.next
    end

    def test_first_not_array
      assert Array != @ins.class , @ins
    end
    def test_class_compiles
      assert_equal MessageSetup , @ins.class , @ins
    end
    def test_two_instructions_are_returned
      assert_equal 8 ,  @ins.length , @ins
    end
    def test_receiver_move_class
      assert_equal ArgumentTransfer,  @ins.next(1).class
    end
    def test_receiver_move
      assert_equal SlotDefinition,  @ins.next.receiver.class
    end
    def test_receiver
      type , value = receiver
      assert_equal type,  @ins.next.receiver.known_object.class
      assert_equal value,  @ins.next.receiver.known_object.value
    end
    def test_call_is
        assert_equal SimpleCall,  @ins.next(2).class
    end
    def test_call_has_method
      assert_equal Parfait::CallableMethod,  @ins.next(2).method.class
    end
    def test_array
      check_array [MessageSetup,ArgumentTransfer,SimpleCall,
                  SlotLoad, ReturnJump, Label, ReturnSequence ,
                    Label] , @ins
    end
  end
end

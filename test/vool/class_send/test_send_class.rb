require_relative "helper"

module Vool
  class TestSendClassMom < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_main( "Object.get_internal_word(0)" , "Object.get" )
      @ins = @compiler.mom_instructions.next
    end

    def test_array
      check_array [MessageSetup,ArgumentTransfer,SimpleCall,SlotLoad,
                    ReturnJump,Label, ReturnSequence , Label] , @ins
    end

    def test_class_compiles
      assert_equal MessageSetup , @ins.class , @ins
    end
    def test_receiver
      assert_equal SlotDefinition,  @ins.next.receiver.class
      assert_equal Parfait::Class,  @ins.next.receiver.known_object.class
      assert_equal :Object ,  @ins.next.receiver.known_object.name
    end
    def test_receiver_move
      assert_equal SlotDefinition,  @ins.next.receiver.class
    end
    def test_receiver
      assert_equal Parfait::Class,  @ins.next.receiver.known_object.class
    end
    def test_arg_one
      assert_equal SlotLoad,  @ins.next(1).arguments[0].class
    end
    def test_receiver_move_class
      assert_equal ArgumentTransfer,  @ins.next(1).class
    end
    def test_call_is
      assert_equal SimpleCall,  @ins.next(2).class
      assert_equal Parfait::CallableMethod,  @ins.next(2).method.class
      assert_equal :get_internal_word,  @ins.next(2).method.name
    end
    def test_call_has_right_receiver
      assert_equal "Class_Type",  @ins.next(2).method.self_type.name
    end
  end
end

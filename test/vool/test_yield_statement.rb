require_relative "helper"

module Vool
  class TestYieldArgsSendMom  < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_main( "return yield(1)" )
      @ins = @compiler.mom_instructions.next
    end

    def test_array
      check_array [NotSameCheck, Label, MessageSetup, ArgumentTransfer, BlockYield ,
                    SlotLoad, ReturnJump, Label, ReturnSequence , Label]  , @ins
    end
    def test_check_label
      assert_equal NotSameCheck, @ins.class
      assert @ins.false_jump.name.start_with?("method_ok_") , @ins.false_jump.name
    end
    def test_transfer
      assert_equal ArgumentTransfer, @ins.next(3).class
      assert_equal 1, @ins.next(3).arguments.length
    end
    def test_args_one_l
      left = @ins.next(3).arguments[0].left
      assert_equal Symbol, left.known_object.class
      assert_equal :message, left.known_object
      assert_equal [:next_message, :arg1], left.slots
    end
    def test_check_left
      assert_equal SlotDefinition, @ins.left.class
      assert_equal Parfait::CallableMethod, @ins.left.known_object.class
      assert_equal :main, @ins.left.known_object.name
      assert @ins.left.slots.empty?
    end
    def test_check_right
      assert_equal SlotDefinition, @ins.right.class
      assert_equal :message, @ins.right.known_object
      assert_equal [:method] , @ins.right.slots
    end
    def test_label
      assert_equal Label, @ins.next(1).class
      assert @ins.next(1).name.start_with?("method_ok_")
    end
    def test_setup
      assert_equal MessageSetup, @ins.next(2).class
      assert_equal 2, @ins.next(2).method_source
    end
    def test_receiver
      assert_equal :message , @ins.next(3).receiver.known_object
      assert_equal [:receiver] , @ins.next(3).receiver.slots
    end
    def test_yield
      assert_equal BlockYield, @ins.next(4).class
      assert_equal 2, @ins.next(4).arg_index
    end
    def test_return_load
      assert_equal SlotLoad, @ins.next(5).class
      assert_equal :message, @ins.next(5).left.known_object
      assert_equal :message, @ins.next(5).right.known_object
      assert_equal [:return_value], @ins.next(5).left.slots
      assert_equal [:return_value], @ins.next(5).right.slots
    end
    def test_return
      assert_equal ReturnJump, @ins.next(6).class
    end
  end
  class TestYieldNoArgsSendMom < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_main( "return yield(some.extra.calls)" )
      @ins = @compiler.mom_instructions.next
    end
    def test_check_label
      assert_equal NotSameCheck, @ins.class
      assert @ins.false_jump.name.start_with?("cache_ok_") , @ins.false_jump.name
    end
    def test_array
      check_array [NotSameCheck, SlotLoad, ResolveMethod, Label, MessageSetup ,
                    ArgumentTransfer, DynamicCall, SlotLoad, NotSameCheck, SlotLoad ,
                    ResolveMethod, Label, MessageSetup, ArgumentTransfer, DynamicCall ,
                    SlotLoad, NotSameCheck, SlotLoad, ResolveMethod, Label ,
                    MessageSetup, ArgumentTransfer, DynamicCall, SlotLoad, NotSameCheck ,
                    Label, MessageSetup, ArgumentTransfer, BlockYield, SlotLoad ,
                    ReturnJump, Label, ReturnSequence, Label]  , @ins
    end
    def test_transfer
      assert_equal ArgumentTransfer, @ins.next(5).class
      assert_equal 0, @ins.next(5).arguments.length
    end
  end
end

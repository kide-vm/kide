require_relative "helper"

module Vool
  class TestIvarMom < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_main( "@a = 5")
      @ins = @compiler.mom_instructions.next
    end

    def test_array
      check_array  [SlotLoad, SlotLoad, ReturnJump, Label, ReturnSequence ,
                    Label] , @ins
    end
    def test_class_compiles
      assert_equal SlotLoad , @ins.class , @ins
      assert @ins.left
      assert_equal :message , @ins.left.known_object
    end
    def test_slot_gets_self
      assert_equal :receiver , @ins.left.slots[0]
    end
    def test_slot_assigns_to_local
      assert_equal :a , @ins.left.slots[-1]
    end
    def test_slot_assigns_something
      assert @ins.right
      assert_equal Mom::IntegerConstant ,  @ins.right.known_object.class
    end
  end
end

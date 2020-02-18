require_relative "../helper"

module SlotMachine
  class TestVariable < MiniTest::Test
    include SlotHelper
    def compile_var(str)
      var = compile(str)
      assert var.is_a?(Slotted) , "Was #{var.class}"
      var
    end
    def test_local
      assert_equal SlottedMessage , compile_var("a").class
    end
    def test_inst
      var = compile_var("@a")
      assert_equal SlottedMessage , var.class
    end
    def test_local_chain
      chain = compile_var("a.b")
      assert_equal Slot , chain.slots.class
      assert_equal :b , chain.slots.next_slot.name
    end
    def test_local_chain2
      chain = compile_var("a.b.c")
      assert_equal Slot , chain.slots.next_slot.next_slot.class
      assert_equal :c , chain.slots.next_slot.next_slot.name
    end
    def test_inst_chain
      chain = compile_var("@a.b")
      assert_equal SlottedMessage , chain.class
      assert_equal Slot , chain.slots.class
      assert_equal :receiver , chain.slots.name
      assert_equal Slot , chain.slots.class
      assert_equal :a , chain.slots.next_slot.name
      assert_equal :b , chain.slots.next_slot.next_slot.name
    end
  end
end

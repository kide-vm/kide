require_relative "helper"

module Vool
  class TestLocalMom < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_main( "a = 5")
      @ins = @compiler.mom_instructions.next
    end

    def test_compiles_not_array
      assert Array != @ins.class , @ins
    end
    def test_class_compiles
      assert_equal Mom::SlotLoad , @ins.class , @ins
    end
    def test_slot_is_set
      assert @ins.left
    end
    def test_slot_starts_at_message
      assert_equal :message , @ins.left.known_object
    end
    def test_slot_gets_local
      assert_equal :local1 , @ins.left.slots[0]
    end
    def test_slot_assigns_something
      assert @ins.right
    end
    def test_slot_assigns_int
      assert_equal Mom::IntegerConstant ,  @ins.right.known_object.class
    end
  end

  class TestArgMom < MiniTest::Test
    include VoolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = compile_main( "arg = 5")
      @ins = @compiler.mom_instructions.next
    end

    def test_class_compiles
      assert_equal Mom::SlotLoad , @ins.class , @ins
    end
    def test_slot_is_set
      assert @ins.left
    end
    def test_slot_starts_at_message
      assert_equal :message , @ins.left.known_object
    end
    def test_slot_gets_arg
      assert_equal :arg1 , @ins.left.slots[0]
    end
    def test_slot_assigns_something
      assert @ins.right
    end
    def test_slot_assigns_int
      assert_equal Mom::IntegerConstant ,  @ins.right.known_object.class
    end
  end

end

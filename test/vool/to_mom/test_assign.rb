require_relative "helper"

module Vool
  class TestAssignMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "arg = 5")
      @first = @stats.first
    end

    def test_class_compiles
      assert_equal Mom::SlotMove , @first.class , @stats
    end
    def test_slot_is_set
      assert @first.left
    end
    def test_slot_starts_at_message
      assert_equal :message , @first.left.known_object
    end
    def test_slot_gets_self
      assert_equal :arguments , @first.left.slots[0]
    end
    def test_slot_assigns_to_local
      assert_equal :arg , @first.left.slots[-1]
    end
    def test_slot_assigns_something
      assert @stats.first.right
    end
    def test_slot_assigns_int
      assert_equal IntegerStatement ,  @first.right.class
    end
  end

  #compiling to an argument should result in different second parameter in the slot array
  class TestArgMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "arg = 5")
      @first = @stats.first
    end

    def test_class_compiles
      assert_equal Mom::SlotMove , @first.class , @stats
    end
    def test_slot_is_set
      assert @first.left
    end
    def test_slot_starts_at_message
      assert_equal :message , @first.left.known_object
    end
    def test_slot_gets_self
      assert_equal :arguments , @first.left.slots[0]
    end
    def test_slot_assigns_to_local
      assert_equal :arg , @first.left.slots[-1]
    end
    def test_slot_assigns_something
      assert @first.right
    end
    def test_slot_assigns_int
      assert_equal IntegerStatement ,  @first.right.class
    end
  end

end

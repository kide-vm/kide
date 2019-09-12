require_relative "helper"

module Vool
  class TestAssignMom < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_main( "local = 5;return")
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

  #otherwise as above, but assigning instance, so should get a SlotLoad
  class TestAssignMomInstanceToLocal < MiniTest::Test
    include VoolCompile
    def setup
      @compiler = compile_main( "@a = 5 ; local = @a;return")
      @ins = @compiler.mom_instructions.next
    end
    def test_class_compiles
      assert_equal Mom::SlotLoad , @ins.next.class , @ins
    end
  end

  #compiling to an argument should result in different second parameter in the slot array
  class TestAssignToArg < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_main( "arg = 5;return")
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
  end

  class TestAssignMomToInstance < MiniTest::Test
    include VoolCompile
    def setup
      Parfait.boot!(Parfait.default_test_options)
    end
    def test_assigns_const
      @compiler = compile_main( "@a = 5;return")
      @ins = @compiler.mom_instructions.next
      assert_equal Mom::SlotLoad , @ins.class , @ins
      assert_equal Mom::IntegerConstant , @ins.right.known_object.class , @ins
    end
    def test_assigns_move
      @compiler = compile_main( "@a = arg;return")
      @ins = @compiler.mom_instructions.next
      assert_equal Mom::SlotLoad , @ins.class , @ins
      assert_equal Mom::SlotDefinition , @ins.right.class , @ins
    end
  end

end

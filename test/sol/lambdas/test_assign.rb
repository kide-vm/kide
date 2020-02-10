require_relative "../helper"

module SolBlocks
  class TestAssignSlotMachine < MiniTest::Test
    include SolCompile

    def setup
      @ins = compile_main_block(  "local = 5" )
    end
    def test_block_compiles
      assert_equal SlotMachine::SlotLoad , @ins.class , @ins
    end
    def test_slot_is_set
      assert @ins.left
    end
    def test_slot_starts_at_message
      assert_equal :message , @ins.left.known_object
    end
    def test_slots_left
      assert_equal [:local1] , @ins.left.slots
    end
    def test_slot_assigns_something
      assert @ins.right
    end
    def test_slot_assigns_int
      assert_equal SlotMachine::IntegerConstant ,  @ins.right.known_object.class
    end
  end

  class TestAssignSlotMachineInstanceToLocal < MiniTest::Test
    include SolCompile
    def setup
      @ins = compile_main_block( "local = @a" , "@a = 5") #second arg in method scope
    end
    def test_class_compiles
      assert_equal SlotMachine::SlotLoad , @ins.class , @ins
    end
    def test_slots_left
      assert_equal [:local1] , @ins.left.slots
    end
    def test_slots_right
      assert_equal [:receiver, :a] , @ins.right.slots
    end
  end

  class TestAssignToArg < MiniTest::Test
    include SolCompile

    def setup
      @ins = compile_main_block( "arg = 5")
    end

    def test_class_compiles
      assert_equal SlotMachine::SlotLoad , @ins.class , @ins
    end
    def test_slot_is_set
      assert @ins.left
    end
    def test_slots_left
      assert_equal [:caller,:caller, :arg1] , @ins.left.slots
    end
  end

  class TestAssignSlotMachineToInstance < MiniTest::Test
    include SolCompile
    def setup
    end
    def test_assigns_const
      @ins = compile_main_block( "@a = 5")
      assert_equal SlotMachine::SlotLoad , @ins.class , @ins
      assert_equal SlotMachine::IntegerConstant , @ins.right.known_object.class , @ins
    end
    def test_assigns_move
      @ins = compile_main_block( "@a = arg")
      assert_equal SlotMachine::SlotLoad , @ins.class , @ins
      assert_equal SlotMachine::MessageDefinition , @ins.right.class , @ins
    end
  end

end

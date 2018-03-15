require_relative "helper"

module Vool
  class TestAssignMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "local = 5")
    end

    def test_class_compiles
      assert_equal Mom::SlotLoad , @stats.class , @stats
    end
    def test_slot_is_set
      assert @stats.left
    end
    def test_slot_starts_at_message
      assert_equal :message , @stats.left.known_object
    end
    def test_slot_gets_self
      assert_equal :frame , @stats.left.slots[0]
    end
    def test_slot_assigns_to_local
      assert_equal :local , @stats.left.slots[-1]
    end
    def test_slot_assigns_something
      assert @stats.right
    end
    def test_slot_assigns_int
      assert_equal Mom::IntegerConstant ,  @stats.right.class
    end
  end

  #otherwise as above, but assigning instance, so should get a SlotMove
  class TestAssignMomInstanceToLocal < MiniTest::Test
    include MomCompile
    def setup
      Risc.machine.boot
      @stats = compile_first_method( "local = @a")
    end
    def test_class_compiles
      assert_equal Mom::SlotLoad , @stats.class , @stats
    end
  end

  #compiling to an argument should result in different second parameter in the slot array
  class TestAssignToArg < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "arg = 5")
    end

    def test_class_compiles
      assert_equal Mom::SlotLoad , @stats.class , @stats
    end
    def test_slot_is_set
      assert @stats.left
    end
    def test_slot_starts_at_message
      assert_equal :message , @stats.left.known_object
    end
    def test_slot_gets_self
      assert_equal :arguments , @stats.left.slots[0]
    end
    def test_slot_assigns_to_local
      assert_equal :arg , @stats.left.slots[-1]
    end
  end

  class TestAssignMomToInstance < MiniTest::Test
    include MomCompile
    def setup
      Risc.machine.boot
    end
    def test_assigns_const
      @stats = compile_first_method( "@a = 5")
      assert_equal Mom::SlotLoad , @stats.class , @stats
      assert_equal Mom::IntegerConstant , @stats.right.class , @stats
    end
    def test_assigns_move
      @stats = compile_first_method( "@a = arg")
      assert_equal Mom::SlotLoad , @stats.class , @stats
      assert_equal Mom::SlotDefinition , @stats.right.class , @stats
    end
  end

end

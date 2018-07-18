require_relative "../helper"

module VoolBlocks
  class TestAssignMom < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!
      Risc::Builtin.boot_functions
      @ins = compile_first_block( "local = 5")
    end

    def test_block_compiles
      assert_equal Mom::SlotLoad , @ins.class , @ins
    end
    def test_slot_is_set
      assert @ins.left
    end
    def test_slot_starts_at_message
      assert_equal :message , @ins.left.known_object
    end
    def test_slot_gets_self
      assert_equal :frame , @ins.left.slots[0]
    end
    def test_slot_assigns_to_local
      assert_equal :local , @ins.left.slots[-1]
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
    include MomCompile
    def setup
      Parfait.boot!
      @ins = compile_first_block( "local = @a" , "@a = 5")
    end
    def test_class_compiles
      assert_equal Mom::SlotLoad , @ins.class , @ins
    end
  end

  #compiling to an argument should result in different second parameter in the slot array
  class TestAssignToArg < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!
      @ins = compile_first_method( "arg = 5")
    end

    def pest_class_compiles
      assert_equal Mom::SlotLoad , @ins.class , @ins
    end
    def pest_slot_is_set
      assert @ins.left
    end
    def pest_slot_starts_at_message
      assert_equal :message , @ins.left.known_object
    end
    def pest_slot_gets_self
      assert_equal :arguments , @ins.left.slots[0]
    end
    def pest_slot_assigns_to_local
      assert_equal :arg , @ins.left.slots[-1]
    end
  end

  class TestAssignMomToInstance < MiniTest::Test
    include MomCompile
    def setup
      Parfait.boot!
    end
    def pest_assigns_const
      @ins = compile_first_method( "@a = 5")
      assert_equal Mom::SlotLoad , @ins.class , @ins
      assert_equal Mom::IntegerConstant , @ins.right.known_object.class , @ins
    end
    def pest_assigns_move
      @ins = compile_first_method( "@a = arg")
      assert_equal Mom::SlotLoad , @ins.class , @ins
      assert_equal Mom::SlotDefinition , @ins.right.class , @ins
    end
  end

end

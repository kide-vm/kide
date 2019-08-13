require_relative "../helper"

module VoolBlocks
  class TestAssignMom < MiniTest::Test
    include VoolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @ins = compile_first_block(  "local = 5" )
    end

    def test_block_compiles
      assert_equal Mom::SlotLoad , @ins.class , @ins
    end
    def pest_slot_is_set
      assert @ins.left
    end
    def pest_slot_starts_at_message
      assert_equal :message , @ins.left.known_object
    end
    def pest_slots_left
      assert_equal [:frame , :local] , @ins.left.slots
    end
    def pest_slot_assigns_something
      assert @ins.right
    end
    def pest_slot_assigns_int
      assert_equal Mom::IntegerConstant ,  @ins.right.known_object.class
    end
  end

  class TestAssignMomInstanceToLocal < MiniTest::Test
    include VoolCompile
    def setup
      Parfait.boot!(Parfait.default_test_options)
      @ins = compile_first_block( "local = @a" , "@a = 5") #second arg in method scope
    end
    def pest_class_compiles
      assert_equal Mom::SlotLoad , @ins.class , @ins
    end
    def pest_slots_left
      assert_equal [:frame, :local] , @ins.left.slots
    end
    def pest_slots_right
      assert_equal [:receiver, :a] , @ins.right.slots
    end
  end

  class TestAssignToArg < MiniTest::Test
    include VoolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @ins = compile_first_block( "arg = 5")
    end

    def pest_class_compiles
      assert_equal Mom::SlotLoad , @ins.class , @ins
    end
    def pest_slot_is_set
      assert @ins.left
    end
    def pest_slots_left
      assert_equal [:caller,:caller, :arguments, :arg] , @ins.left.slots
    end
  end

  class TestAssignMomToInstance < MiniTest::Test
    include VoolCompile
    def setup
      Parfait.boot!(Parfait.default_test_options)
    end
    def pest_assigns_const
      @ins = compile_first_block( "@a = 5")
      assert_equal Mom::SlotLoad , @ins.class , @ins
      assert_equal Mom::IntegerConstant , @ins.right.known_object.class , @ins
    end
    def pest_assigns_move
      @ins = compile_first_block( "@a = arg")
      assert_equal Mom::SlotLoad , @ins.class , @ins
      assert_equal Mom::SlotDefinition , @ins.right.class , @ins
    end
  end

end

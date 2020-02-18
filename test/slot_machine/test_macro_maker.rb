require_relative "helper"

module SlotMachine

  class TestMacroMakerLoad < MiniTest::Test
    include SlotHelper

    def check_mini(maker)
      assert_equal MacroMaker , maker.class
      assert_equal SlotMachine::Label , maker.instructions.class
    end
    def mini_file
       File.read(File.expand_path(  "../codes/mini.slot" , __FILE__))
    end
    def test_mini_string
      check_mini MacroMaker.load_string( mini_file )
    end
    def test_mini_source
      check_mini MacroMaker.new( SlotCompiler.compile(mini_file))
    end
  end

  class TestMacroMakerLoad2 < MiniTest::Test

    def setup
      @macro = MacroMaker.load_string( mini_file )
      @instructions = @macro.instructions
    end
    def test_label
      assert_equal SlotMachine::Label , @macro.instructions.class
    end
    def test_assign
      assert_equal SlotMachine::SlotLoad , @instructions.next.class
      assert_equal "message.receiver.a" , @instructions.next.left.to_s
      assert_equal "message.b" , @instructions.next.right.to_s
    end
    def test_length
      assert @instructions.next
      assert_nil @instructions.next.next
    end
    def mini_file
       File.read(File.expand_path(  "../codes/mini.slot" , __FILE__))
    end

  end

end

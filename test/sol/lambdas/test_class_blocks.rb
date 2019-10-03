require_relative "../helper"

module SolBlocks
  class TestClassAssignSlotMachine < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
    end
    def as_class_method(source)
      "class Space;def self.main();#{source};end;end"
    end
    def test_block_not_compiles
      source =  "main{|val| val = 0}"
      sol = Ruby::RubyCompiler.compile( as_class_method(source) ).to_sol
      sol.to_parfait
      begin
        sol.to_slot(nil)
     rescue => err
        assert err.message.include?("Blocks") , err.message
      end
    end
    def test_assign_compiles
      sol = Ruby::RubyCompiler.compile( as_class_method("val = 0") ).to_sol
      sol.to_parfait
      assert_equal SlotMachine::SlotCollection , sol.to_slot(nil).class
    end
  end
end

require_relative "../helper"

module RubyX
  class TestIntegerCompile < MiniTest::Test
    include ParfaitHelper
    def setup
      @compiler = compiler
      @compiler.ruby_to_sol load_parfait(:object)
      @compiler.ruby_to_sol load_parfait(:data_object)
    end
    def source
      get_preload("Space.main") + load_parfait(:integer)
    end
    def test_load
      assert source.include?("class Integer")
      assert source.length > 1500 , source.length
    end
    def test_sol
      sol = @compiler.ruby_to_sol source
      assert_equal Sol::ScopeStatement , sol.class
      assert_equal Sol::ClassExpression , sol[0].class
      assert_equal Sol::ClassExpression , sol[1].class
      assert_equal Sol::ClassExpression , sol[2].class
      assert_equal :DataObject , sol[1].name
      assert_equal :Data4 , sol[2].name
      assert_equal :Data8 , sol[3].name
    end
    def test_slot
      sol = @compiler.ruby_to_sol source
      sol.to_parfait
      #puts sol
      slot = sol.to_slot(nil)
      assert_equal SlotMachine::SlotCollection , slot.class
    end
    def est_risc
      risc = compiler.ruby_to_risc source
      assert_equal Risc::RiscCollection , risc.class
    end
    def est_binary
      risc = compiler.ruby_to_binary source , :interpreter
      assert_equal Risc::Linker , risc.class
    end
  end
end

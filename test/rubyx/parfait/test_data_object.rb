require_relative "../helper"

module RubyX

  class TestDatObjectCompile < MiniTest::Test
    include ParfaitHelper
    include Preloader

    def setup
      @compiler = compiler
      @compiler.ruby_to_sol load_parfait(:object)
    end
    def source
      load_parfait(:data_object)
    end
    def test_load
      assert source.include?("class DataObject")
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
      slot = @compiler.ruby_to_slot source
      assert_equal SlotMachine::SlotCollection , slot.class
    end
    def test_risc
      risc = compiler.ruby_to_risc( get_preload("Space.main") + source)
      assert_equal Risc::RiscCollection , risc.class
    end
    def test_binary
      risc = compiler.ruby_to_binary( get_preload("Space.main") + source , :interpreter)
      assert_equal Risc::Linker , risc.class
    end
  end
end

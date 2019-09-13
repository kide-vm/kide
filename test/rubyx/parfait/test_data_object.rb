require_relative "../helper"

module RubyX

  class TestDatObjectCompile < MiniTest::Test
    include ParfaitHelper
    include Preloader

    def setup
      @compiler = compiler
      @compiler.ruby_to_vool load_parfait(:object)
    end
    def source
      load_parfait(:data_object)
    end
    def test_load
      assert source.include?("class DataObject")
      assert source.length > 1500 , source.length
    end
    def test_vool
      vool = @compiler.ruby_to_vool source
      assert_equal Vool::ScopeStatement , vool.class
      assert_equal Vool::ClassExpression , vool[0].class
      assert_equal Vool::ClassExpression , vool[1].class
      assert_equal Vool::ClassExpression , vool[2].class
      assert_equal :DataObject , vool[1].name
      assert_equal :Data4 , vool[2].name
      assert_equal :Data8 , vool[3].name
    end
    def test_mom
      mom = @compiler.ruby_to_mom source
      assert_equal Mom::MomCollection , mom.class
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

require_relative "helper"

module RubyX

  class TestObjecCompile < MiniTest::Test
    include ParfaitHelper
    def source
      load_parfait(:object)
    end
    def test_load
      assert source.include?("class Object")
      assert source.length > 2000
    end
    def test_vool
      vool = compiler.ruby_to_vool source
      assert_equal Vool::ClassStatement , vool.class
      assert_equal :Object , vool.name
    end
    def test_mom
      vool = compiler.ruby_to_mom source
      assert_equal Mom::MomCollection , vool.class
    end
  end
end

require_relative "helper"

module Mom
  class TestMethodCompiler < MiniTest::Test
    include ScopeHelper

    def setup
    end

    def in_test_vool(str)
      vool = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_vool(in_Test(str))
      vool.to_mom(nil)
      vool
    end
    def in_test_mom(str)
      FIXMERubyX::RubyXCompiler.new(in_Test(str)).ruby_to_mom()
    end
    def create_method(body = "@ivar = 5")
      in_test_vool("def meth; #{body};end")
      test = Parfait.object_space.get_class_by_name(:Test)
      test.get_method(:meth)
    end

    def test_method_has_source
      method = create_method
      assert_equal Vool::IvarAssignment ,  method.source.class
    end
  end
end

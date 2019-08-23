require_relative "helper"

module Mom
  class TestMethodCompiler < MiniTest::Test
    include ScopeHelper

    def setup
    end

    def in_test_vool(body = "@ivar = 5;return")
      code = in_Test("def meth; #{body};end")
      RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_mom(code)
    end

    def test_method
      in_test_vool()
      method = Parfait.object_space.get_class_by_name(:Test).get_method(:meth)
      assert_equal Parfait::VoolMethod , method.class
    end
    def test_method_mom_col
      mom = in_test_vool()
      assert_equal Mom::MomCollection ,  mom.class
      assert_equal Mom::MethodCompiler ,  mom.compilers.first.class
    end
    def test_compiles_risc
      compiler = in_test_vool().compilers.first.to_risc
      assert_equal Risc::MethodCompiler , compiler.class
      assert_equal Risc::Label , compiler.risc_instructions.class
    end
    def test_compiles_all_risc
      compiler = in_test_vool().compilers.first.to_risc
      assert_equal Risc::LoadConstant , compiler.risc_instructions.next.class
      assert_equal 16 , compiler.risc_instructions.length
    end
  end
end

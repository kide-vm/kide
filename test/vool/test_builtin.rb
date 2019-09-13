require_relative "helper"

module Vool
  class TestBuiltin < MiniTest::Test
    include VoolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @code = Builtin.boot_methods({})
    end
    def as_ruby
      @ruby = Ruby::RubyCompiler.compile(@code)
    end
    def test_boot
      assert_equal String , @code.class
      assert @code.include?("Integer")
    end
    def test_compile_ruby
      assert_equal Ruby::ClassStatement , as_ruby.class
      assert_equal Ruby::MethodStatement , @ruby.body.first.class
      assert_equal :+ , @ruby.body.first.name
    end
    def test_compile_vool
      vool = as_ruby.to_vool
      assert_equal Vool::ClassExpression , vool.class
      assert_equal Vool::MethodExpression , vool.body.first.class
    end
    def test_vool_method
      vool = as_ruby.to_vool
      assert_equal :+ , vool.body.first.name
      assert_equal Vool::ReturnStatement , vool.body.first.body.class
      assert_equal Vool::MacroExpression , vool.body.first.body.return_value.class
    end
    def test_mom_basic
      mom = as_ruby.to_vool.to_mom(nil)
      assert_equal Mom::MomCollection , mom.class
      assert_equal Mom::MethodCompiler , mom.method_compilers.first.class
    end
    def test_mom_instructions
      mom_compiler = as_ruby.to_vool.to_mom(nil).method_compilers.first
      assert_equal Mom::Label , mom_compiler.mom_instructions.class
      assert_equal Mom::IntOperator , mom_compiler.mom_instructions.next.class
      assert_equal Mom::SlotLoad , mom_compiler.mom_instructions.next(2).class
      assert_equal Mom::ReturnJump , mom_compiler.mom_instructions.next(3).class
    end
  end
end

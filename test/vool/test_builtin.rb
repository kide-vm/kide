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
    def as_slot
      vool = as_ruby.to_vool
      vool.to_parfait
      vool.to_slot(nil)
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
    def test_slot_basic
      slot = as_slot
      assert_equal SlotMachine::SlotCollection , slot.class
      assert_equal SlotMachine::MethodCompiler , slot.method_compilers.class
    end
    def test_slot_instructions
      slot_compiler = as_slot.method_compilers
      assert_equal SlotMachine::Label , slot_compiler.slot_instructions.class
      assert_equal SlotMachine::IntOperator , slot_compiler.slot_instructions.next.class
      assert_equal SlotMachine::SlotLoad , slot_compiler.slot_instructions.next(2).class
      assert_equal SlotMachine::ReturnJump , slot_compiler.slot_instructions.next(3).class
    end
  end
end

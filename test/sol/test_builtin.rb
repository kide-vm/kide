require_relative "helper"

module Sol
  class TestBuiltin < MiniTest::Test
    include SolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @code = Builtin.boot_methods({})
    end
    def as_ruby
      @ruby = Ruby::RubyCompiler.compile(@code)
    end
    def as_slot
      sol = as_ruby.to_sol
      sol.to_parfait
      sol.to_slot(nil)
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
    def test_compile_sol
      sol = as_ruby.to_sol
      assert_equal Sol::ClassExpression , sol.class
      assert_equal Sol::MethodExpression , sol.body.first.class
    end
    def test_sol_method
      sol = as_ruby.to_sol
      assert_equal :+ , sol.body.first.name
      assert_equal Sol::ReturnStatement , sol.body.first.body.class
      assert_equal Sol::MacroExpression , sol.body.first.body.return_value.class
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

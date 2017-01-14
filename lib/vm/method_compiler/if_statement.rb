module Vm
  module IfStatement

    # an if evaluates the condition and jumps to the true block if true
    # so the else block is automatically after that.
    # But then the else needs to jump over the true block unconditionally.
    def on_IfStatement( statement )
#      branch_type , condition , if_true , if_false = *statement

      true_block = compile_if_condition( statement )
      merge = compile_if_false( statement )
      add_code true_block
      compile_if_true(statement)
      add_code merge
      nil # statements don't return anything
    end

    private

    def compile_if_condition( statement )
      reset_regs
      process(statement.condition)
      branch_class = Object.const_get "Register::Is#{statement.branch_type.capitalize}"
      true_block = Register.label(statement, "if_true")
      add_code branch_class.new( statement.condition , true_block )
      return true_block
    end
    def compile_if_true( statement )
      reset_regs
      process(statement.if_true)
    end

    def compile_if_false( statement )
      reset_regs
      process(statement.if_false) if statement.if_false.statements
      merge = Register.label(statement , "if_merge")
      add_code Register::Branch.new(statement.if_false, merge )
      merge
    end
  end
end

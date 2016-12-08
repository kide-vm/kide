module Typed
  Compiler.class_eval do

    # an if evaluates the condition and jumps to the true block if true
    # so the else block is automatically after that.
    # But then the else needs to jump over the true block unconditionally.
    def on_IfStatement statement
#      branch_type , condition , if_true , if_false = *statement
#      condition = condition.first

      reset_regs
      process(statement.condition)

      branch_class = Object.const_get "Register::Is#{statement.branch_type.capitalize}"
      true_block = Register::Label.new(statement, "if_true")
      add_code branch_class.new( statement.condition , true_block )

      # compile the false block
      reset_regs
      process(statement.if_false) if statement.if_false.statements
      merge = Register::Label.new(statement , "if_merge")
      add_code Register::Branch.new(statement.if_false, merge )

      # compile the true block
      add_code true_block
      reset_regs
      process(statement.if_true)

      #puts "compiled if: end"
      add_code merge

      nil # statements don't return anything
    end
  end
end

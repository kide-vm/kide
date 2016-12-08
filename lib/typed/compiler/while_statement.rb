module Typed
  Compiler.class_eval do

    def on_WhileStatement statement
      #puts statement.inspect
      #branch_type , condition , statements = *statement

      condition_label = Register::Label.new(statement.condition , "condition_label")
      # unconditionally branch to the condition upon entering the loop
      add_code Register::Branch.new(statement.condition,condition_label)

      add_code  start = Register::Label.new(statement , "while_start" )
      reset_regs
      process(statement.statements)

      # This is where the loop starts, though in subsequent iterations it's in the middle
      add_code condition_label
      reset_regs
      process(statement.condition)

      branch_class = Object.const_get "Register::Is#{statement.branch_type.capitalize}"
      # this is where the while ends and both branches meet
      add_code branch_class.new( statement.condition , start )

      nil # statements don't return anything
    end
  end
end

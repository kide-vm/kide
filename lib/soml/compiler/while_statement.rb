module Soml
  Compiler.class_eval do

    def on_while_statement statement
      #puts statement.inspect
      branch_type , condition , statements = *statement
      condition = condition.first

      condition_label = Register::Label.new(statement , "condition_label")
      # unconditionally branch to the condition upon entering the loop
      add_code Register::Branch.new(statement,condition_label)

      add_code  start = Register::Label.new(statement , "while_start" )
      reset_regs
      process_all(statements)

      # This is where the loop starts, though in subsequent iterations it's in the middle
      add_code condition_label
      reset_regs
      process(condition)

      branch_class = Object.const_get "Register::Is#{branch_type.capitalize}"
      # this is where the while ends and both branches meet
      add_code branch_class.new( condition , start )

      nil # statements don't return anything
    end
  end
end

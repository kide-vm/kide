module Soml
  Compiler.class_eval do

    def on_while_statement statement
      #puts statement.inspect
      branch_type , condition , statements = *statement
      condition = condition.first

      add_code  start = Register::Label.new(statement , "while_start" )

      reset_regs
      process(condition)

      branch_class = Object.const_get "Register::Is#{branch_type.capitalize}"
      # this is where the while ends and both branches meet
      merge = Register::Label.new(statement , "while_merge")
      add_code branch_class.new( condition , merge )

      reset_regs
      process_all(statements)

      # unconditionally branch to the start
      add_code Register::Branch.new(statement,start)

      # continue execution / compiling at the merge block
      add_code merge
      nil # statements don't return anything
    end
  end
end

module Typed
  module WhileStatement

    def on_WhileStatement statement
      #branch_type , condition , statements = *statement

      condition_label = compile_while_preamble( statement )  #jump there

      start = compile_while_body( statement )

      # This is where the loop starts, though in subsequent iterations it's in the middle
      add_code condition_label

      compile_while_condition( statement )

      branch_class = Object.const_get "Register::Is#{statement.branch_type.capitalize}"
      # this is where the while ends and both branches meet
      add_code branch_class.new( statement.condition , start )

      nil # statements don't return anything
    end
    private

    def compile_while_preamble( statement )
      condition_label = Register.label(statement.condition , "condition_label")
      # unconditionally branch to the condition upon entering the loop
      add_code Register::Branch.new(statement.condition , condition_label)
      condition_label
    end
    def compile_while_body( statement )
      start = Register.label(statement , "while_start" )
      add_code start
      reset_regs
      process(statement.statements)
      start
    end
    def compile_while_condition( statement )
      reset_regs
      process(statement.condition)
    end
  end
end

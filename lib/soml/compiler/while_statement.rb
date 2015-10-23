module Soml
  Compiler.class_eval do

    def on_while_statement statement
      #puts statement.inspect
      branch_type , condition , statements = *statement
      condition = condition.first

      # this is where the while ends and both branches meet
      merge = @method.source.new_block("while merge")
      # this comes after the current and beofre the merge
      start = @method.source.new_block("while_start" )
      @method.source.current start

      cond = process(condition)

      branch_class = Object.const_get "Register::Is#{branch_type.capitalize}"
      add_code branch_class.new( condition , merge )

      last = process_all(statements).last

      # unconditionally branch to the start
      add_code Register::Branch.new(statement,start)

      # continue execution / compiling at the merge block
      @method.source.current merge
      last
    end
  end
end

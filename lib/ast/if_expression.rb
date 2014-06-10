module Ast
  class IfExpression < Expression
#    attr_reader  :cond, :if_true, :if_false
    def compile context
      f = context.function
      # to execute the logic as the if states it, the blocks are the other way around
      # so we can the jump over the else if true ,and the else joins unconditionally after the true_block
      false_block = f.new_block "if_false"
      true_block = f.new_block "if_true"
      merge_block = f.new_block "if_merge"

      puts "compiling if condition #{cond}"
      cond_val = cond.compile(context)
      f.b true_block , condition_code: cond_val.operator
      f.insertion_point.branch = true_block

      f.insert_at false_block
      if_false.each do |part|
        puts "compiling in if false #{part}"
        last = part.compile(context  )
      end
      f.b merge_block
      f.insertion_point.branch = false_block

      f.insert_at true_block
      last = nil
      if_true.each do |part|
        puts "compiling in if true #{part}"
        last = part.compile(context )
      end

      puts "compiled if: end"
      f.insert_at merge_block

      return last
    end
  end
end
module Ast
  class IfExpression < Expression
#    attr_reader  :cond, :if_true, :if_false
    def compile context , into
      # to execute the logic as the if states it, the blocks are the other way around
      # so we can the jump over the else if true ,and the else joins unconditionally after the true_block
      false_block = into.new_block "#{into.name}_if_false"
      true_block = false_block.new_block "#{into.name}_if_true"
      merge_block = true_block.new_block "#{into.name}_if_merge"

      puts "compiling if condition #{cond}"
      cond_val = cond.compile(context , into)
      into.b true_block , condition_code: cond_val.operator
            
      if_false.each do |part|
        puts "compiling in if false #{part}"
        last = part.compile(context , false_block )
      end
      false_block.b merge_block

      last = nil
      if_true.each do |part|
        puts "compiling in if true #{part}"
        last = part.compile(context , true_block )
      end

      puts "compiled if: end"
      into.insert_at merge_block

      return last
    end
  end
end
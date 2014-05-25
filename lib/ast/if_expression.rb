module Ast
  class IfExpression < Expression
    attr_reader  :cond, :if_true, :if_false
    def initialize cond, if_true, if_false
      @cond, @if_true, @if_false = cond, if_true, if_false
    end
    def inspect
      self.class.name + ".new(" + cond.inspect + ", "+ 
        if_true.inspect +  ","  + if_false.inspect + " )"  
    end
    def attributes
      [:cond, :if_true, :if_false]
    end
    def compile context , into
      # to execute the logic as the if states it, the blocks are the other way around
      # so we can the jump over the else if true ,and the else joins unconditionally after the true_block
      false_block = into.new_block "#{into.name}_if_false"
      true_block = false_block.new_block "#{into.name}_if_true"
      merge_block = true_block.new_block "#{into.name}_if_merge"

      cond_val = cond.compile(context , into)
      puts "compiled if condition #{cond_val.inspect}"
      into.b true_block , condition_code: cond_val.operator
            
      if_false.each do |part|
        last = part.compile(context , false_block )
        puts "compiled in if false #{last.inspect}"
      end
      false_block.b merge_block

      last = nil
      if_true.each do |part|
        last = part.compile(context , true_block )
        puts "compiled in if true #{last.inspect}"
      end

      puts "compile if end"
      into.insert_at merge_block

      return last
    end
  end
end
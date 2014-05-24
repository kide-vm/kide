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
      false_block = into.new_block "#{into.name}_else"
      merge_block = false_block.new_block "#{into.name}_if_merge"

      cond_val = cond.compile(context , into)
      puts "compiled if condition #{cond_val.inspect}"
      into.b false_block , condition_code: cond_val.not_operator
            
      last = nil
      if_true.each do |part|
        last = part.compile(context , into )
        puts "compiled in if true #{last.inspect}"
      end
      
      into.b merge_block

      if_false.each do |part|
        last = part.compile(context , false_block )
        puts "compiled in if false #{last.inspect}"
      end
      
      puts "compile if end"
      into.insert_at merge_block

      return last
    end
  end
end
module Virtual
  module Compiler
#    if - attr_reader  :cond, :if_true, :if_false

    def self.compile_if expression , method
      # to execute the logic as the if states it, the blocks are the other way around
      # so we can the jump over the else if true ,and the else joins unconditionally after the true_block
      merge_block = method.info.new_block "if_merge"    # last one, created first
      true_block =  method.info.new_block "if_true"     # second, linked in after current, before merge
      false_block = method.info.new_block "if_false"    # directly next in order, ie if we don't jump we land here


      is = Compiler.compile(expression.cond, method )
      # TODO should/will use different branches for different conditions.
      # just a scetch : cond_val = cond_val.is_true?(method) unless cond_val.is_a? BranchCondition
      method.info.add_code IsTrueBranch.new( true_block )

      # compile the true block (as we think of it first, even it is second in sequential order)
      method.info.current true_block
      last = is
      expression.if_true.each do |part|
        last = Compiler.compile(part,method  )
        raise part.inspect if last.nil?
      end

      # compile the false block
      method.info.current false_block
      expression.if_false.each do |part|
        #puts "compiling in if false #{part}"
        last = Compiler.compile(part,method )
        raise part.inspect if last.nil?
      end
      method.info.add_code UnconditionalBranch.new( merge_block )

      #puts "compiled if: end"
      method.info.current merge_block

      #TODO should return the union of the true and false types
      last
    end
  end
end

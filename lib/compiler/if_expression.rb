module Compiler
#    if - attr_reader  :cond, :if_true, :if_false

    def compile_if expression , method , message
      # to execute the logic as the if states it, the blocks are the other way around
      # so we can the jump over the else if true ,and the else joins unconditionally after the true_block
      merge_block = method.new_block "if_merge"    # last one, created first
      true_block =  method.new_block "if_true"     # second, linked in after current, before merge
      false_block = method.new_block "if_false"    # directly next in order, ie if we don't jump we land here


      is = cond.compile(method,message)
      # TODO should/will use different branches for different conditions.
      # just a scetch : cond_val = cond_val.is_true?(method) unless cond_val.is_a? Virtual::BranchCondition
      method.add_code Virtual::IsTrueBranch.new( true_block )

      # compile the true block (as we think of it first, even it is second in sequential order)
      method.current true_block
      last = is
      if_true.each do |part|
        last = part.compile(method,message )
        raise part.inspect if last.nil?
      end

      # compile the false block
      method.current false_block
      if_false.each do |part|
        puts "compiling in if false #{part}"
        last = part.compile(method,message)
        raise part.inspect if last.nil?
      end
      method.add_code Virtual::UnconditionalBranch.new( merge_block )

      puts "compiled if: end"
      method.current merge_block

      #TODO should return the union of the true and false types
      last
    end
end

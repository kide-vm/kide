module Ast
  class IfExpression < Expression
#    attr_reader  :cond, :if_true, :if_false
    def compile method , frame
      is = cond.compile(method,frame)
      #      is.is_false(frame,method)
      # TODO should/will use different branches for different conditions. 
      branch = Virtual::ImplicitBranch.new "if_merge"
      method.add branch
      last = is
      if_true.each do |part|
        last = part.compile(method,frame )
        raise part.inspect if last.nil?
      end
      merge = Virtual::Label.new(branch.name)
      method.add merge
      branch.swap
      method.current = branch
      if_false.each do |part|
        last = part.compile(method,frame )
        raise part.inspect if last.nil?
      end
      method.add merge
      branch.swap
      method.current = merge
      #TODO should return the union of the true and false types
      last
    end
  end
end
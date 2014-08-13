module Ast
  class WhileExpression < Expression
#    attr_reader  :condition, :body
    def compile method , message
      start = Virtual::Label.new("while_start")
      method.add_code start
      is = condition.compile(method,message)
      branch = Virtual::ImplicitBranch.new "while"
      merge = Virtual::Label.new(branch.name)
      branch.other = merge   #false jumps to end of while
      method.add_code branch
      last = is
      body.each do |part|
        last = part.compile(method,message )
        raise part.inspect if last.nil?
      end
      # unconditionally brnach to the start
      merge.next = method.current.next
      method.current.next = start
      # here we add the end of while that the branch jumps to
      #but don't link it in (not using add)
      method.current =  merge
      last
    end
  end
end
module Virtual
  module Compiler

#    while- attr_reader  :condition, :body
    def self.compile_while expression, method
      start = Label.new("while_start")
      method.add_code start
      is = expression.condition.compile(method )
      branch = IsTrueBranch.new "while"
      merge = Label.new(branch.name)
      branch.other = merge   #false jumps to end of while
      method.add_code branch
      last = is
      expression.body.each do |part|
        last = part.compile(method  )
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

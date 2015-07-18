module Virtual
  module Compiler

#    while- attr_reader  :condition, :body
    def self.compile_while expression, method
      # this is where the while ends and both branches meet
      merge = method.source.new_block("while merge")
      # this comes after the current and beofre the merge
      start = method.source.new_block("while_start" )
      method.source.current start

      cond = Compiler.compile(expression.condition, method)

      method.source.add_code IsTrueBranch.new(merge)

      last = cond
      expression.body.each do |part|
        last = Compiler.compile(part , method)
        raise part.inspect if last.nil?
      end
      # unconditionally branch to the start
      method.source.add_code UnconditionalBranch.new(start)

      # continue execution / compiling at the merge block
      method.source.current merge
      last
    end
  end
end

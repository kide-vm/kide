module Virtual
  module Compiler
#    list - attr_reader  :expressions
    def self.compile_list expession , method
      expession.expressions.collect do |part|
        Compiler.compile(  part , method )
      end
    end
  end
end

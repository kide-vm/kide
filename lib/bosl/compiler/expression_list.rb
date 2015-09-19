module Bosl
  module Compiler
#    list - attr_reader  :expressions
    def self.compile_expressions expession , method
      expession.children.collect do |part|
        Compiler.compile(  part , method )
      end
    end
  end
end

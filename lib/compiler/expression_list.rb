module Compiler
#    list - attr_reader  :expressions
    def self.compile_list expession , method , message
      expession.expressions.collect do |part|
        Compiler.compile(  part , method, message )
      end
    end
end

module Compiler
#    list - attr_reader  :expressions
    def compile_list expession , method , message
      expession.expressions.collect { |part|  part.compile( method, message ) }
    end
end

module Phisol
  Compiler.class_eval do
#    list - attr_reader  :expressions
    def on_expressions expession
      process_all(  expession.children  )
    end
  end
end

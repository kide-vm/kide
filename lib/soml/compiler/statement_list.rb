module Soml
  Compiler.class_eval do

    def on_statements statement
      process_all(  statement.children  )
    end
  end
end

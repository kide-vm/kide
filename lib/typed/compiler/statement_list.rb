module Typed
  module StatementList
    def on_statements statement
      process_all(  statement.children  )
    end
  end
end

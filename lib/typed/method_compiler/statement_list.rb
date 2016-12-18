module Typed
  module StatementList
    def on_Statements statement
      process_all(  statement.statements  )
    end
  end
end

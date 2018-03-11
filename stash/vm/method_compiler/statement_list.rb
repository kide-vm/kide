module Vm
  module StatementList
    def on_Statements statement
      process_all(  statement.statements  )
    end
  end
end

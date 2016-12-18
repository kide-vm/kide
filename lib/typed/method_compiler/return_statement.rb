module Typed
  module ReturnStatement

    def on_ReturnStatement statement
      reg =  process(statement.return_value)
      add_code Register.set_slot( statement, reg , :message , :return_value)
      nil # statements don't return
    end
  end
end

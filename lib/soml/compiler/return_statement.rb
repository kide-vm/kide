module Soml
  Compiler.class_eval do

    def on_return statement
      reg =  process(statement.first )
      add_code Register.set_slot( statement, reg , :message , :return_value)
      nil # statements don't return
    end
  end
end

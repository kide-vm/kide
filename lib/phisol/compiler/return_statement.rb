module Phisol
  Compiler.class_eval do

#    return attr_reader  :statement
    def on_return statement
      return process(statement.to_a.first )
    end
  end
end

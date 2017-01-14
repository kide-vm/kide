module Vm
  module OperatorExpression

    def on_OperatorExpression statement
      #      operator , left_e , right_e = *statement
      # left and right must be expressions. Expressions return a register when compiled
      left_reg = process(statement.left_expression)
      right_reg = process(statement.right_expression)
      raise "Not register #{left_reg}" unless left_reg.is_a?(Register::RegisterValue)
      raise "Not register #{right_reg}" unless right_reg.is_a?(Register::RegisterValue)
      add_code Register::OperatorInstruction.new(statement,statement.operator,left_reg,right_reg)
      return left_reg # though this has wrong value attached
    end
  end
end

module Parser
  module FunctionCall
    include Parslet

    rule(:argument_list) {
      left_parenthesis >>
      (  (value_expression.as(:argument) >> space? >>
          (comma >> space? >> value_expression.as(:argument)).repeat(0)).repeat(0,1)).as(:argument_list) >>
          space? >> right_parenthesis
    }

    rule(:function_call) { name.as(:function_call) >> argument_list }

    
  end
end

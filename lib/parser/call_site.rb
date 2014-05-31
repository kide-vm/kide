module Parser
  module CallSite
    include Parslet

    rule(:argument_list) {
      left_parenthesis >>
      (  ((operator_expression|value_expression).as(:argument) >> space? >>
          (comma >> space? >> (operator_expression|value_expression).as(:argument)).repeat(0)).repeat(0,1)).as(:argument_list) >>
          space? >> right_parenthesis
    }

    rule(:call_site) { (name.as(:receiver) >> str(".")).repeat(0,1) >> name.as(:call_site) >> argument_list >> comment.maybe}

    
  end
end

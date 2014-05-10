module Parser
  module FunctionDefinition
    include Parslet
    
    rule(:function_definition) {
      keyword_def >> name.as(:function_definition) >> parmeter_list >> newline >> expressions_end
    }

    rule(:parmeter_list) {
      left_parenthesis >>
        ((name.as(:parmeter) >> (comma >> name.as(:parmeter)).repeat(0)).repeat(0,1)).as(:parmeter_list) >>
      right_parenthesis
    }

  end
end

module Parser
  module FunctionDefinition
    include Parslet
    
    rule(:function_definition) {
      keyword_def >> ((module_name|instance_variable|name).as(:receiver) >> str(".")).maybe >> #possibly qualified
                  name.as(:function_name) >> parmeter_list >> newline >> expressions_end >> newline
    }

    rule(:parmeter_list) {
      left_parenthesis >>
        ((name.as(:parmeter) >> (comma >> name.as(:parmeter)).repeat(0)).repeat(0,1)).as(:parmeter_list) >>
      right_parenthesis
    }

  end
end

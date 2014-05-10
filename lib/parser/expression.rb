module Parser
  module Expression
    include Parslet
    
    rule(:assignment) { name.as(:asignee) >> equal_sign >> expression.as(:asigned)  }

    rule(:simple_expression) { function_call | integer | string | name }
    rule(:expression) { (conditional | simple_expression ) >> newline.maybe }

    def delimited_expressions( delimit )
      ( (delimit.absent? >> (assignment | expression)).repeat(1)).as(:expressions) >> delimit >> newline.maybe
    end

    rule(:expressions_else)   { delimited_expressions(keyword_else) }
    rule(:expressions_end)    { delimited_expressions(keyword_end) }

  end
end

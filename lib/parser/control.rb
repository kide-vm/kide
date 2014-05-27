module Parser
  module Control
    include Parslet
    rule(:conditional) do
      keyword_if >> 
      (( (value_expression|operator_expression).as(:conditional) ) |
        left_parenthesis >> (operator_expression|value_expression).as(:conditional) >>  right_parenthesis) >>
      newline >> expressions_else.as(:if_true) >> newline >> expressions_end.as(:if_false)
      end
    
    rule(:while_do) do
      keyword_while  >> left_parenthesis >> (operator_expression|value_expression).as(:while_cond)  >>
                                          right_parenthesis >> keyword_do >> newline >>
                              expressions_end.as(:body)
    end
    rule(:simple_return) do
      keyword_return >> (operator_expression|value_expression).as(:return_expression) >> eol
    end
  end
end

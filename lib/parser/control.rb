module Parser
  module Control
    include Parslet
    rule(:conditional) do
      keyword_if >> left_parenthesis >> expression.as(:conditional) >> right_parenthesis >> newline >>
        expressions_else.as(:if_true) >> expressions_end.as(:if_false)
      end
    
    rule(:while_do) do
      keyword_while  >> left_parenthesis >> expression.as(:while_cond)  >> right_parenthesis >> 
                                                                    keyword_do >> newline >> 
                              expressions_end.as(:body)
    end
  end
end

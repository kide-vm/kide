module Parser
  module Operators
    include Parslet
    rule(:exponent) { str('**') >> space?}
    rule(:multiply) { match['*/%']  >> space? }
    rule(:plus) { match['+-']  >> space? }
    rule(:shift) { str(">>") | str("<<") >> space?}
    rule(:bit_and) { str('&') >> space?}
    rule(:bit_or) { str('|') >> space?}
    rule(:greater_equal) { str('>=') >> space?}
    rule(:smaller_equal) { str('<=') >> space?}
    rule(:larger) { str('>') >> space?}
    rule(:smaller) { str('<') >> space?}
    rule(:identity) { str('===') >> space?}
    rule(:equal) { str('==') >> space?}
    rule(:not_equal) { str('!=') >> space?}
    rule(:boolean_and) { str('&&') | str("and") >> space?}
    rule(:boolean_or) { str('||') | str("or") >> space?}
    rule(:assign) { str('=') >> space?}
    rule(:op_assign) { str('+=')|str('-=')|str('*=')|str('/=')|str('%=') >> space?}
    rule(:eclipse) { str('..') |str("...") >> space?}
    rule(:assign) { str('=') >> space?}
  
    #infix doing the heavy lifting here, 
    # is defined as an expressions and array of [atoms,priority,binding] triples
    rule(:operator_expression) do infix_expression(value_expression,
                                     [exponent, 120, :left] ,
                                     [multiply, 120, :left] ,
                                     [plus, 110, :left],
                                     [shift, 100, :left],
                                     [bit_and, 90, :left],
                                     [bit_or, 90, :right],
                                     [greater_equal, 80, :left],
                                     [smaller_equal, 80, :left],
                                     [larger, 80, :left],
                                     [smaller, 80, :left],
                                     [identity, 70, :right],
                                     [equal, 70, :right],
                                     [not_equal, 70, :right],
                                     [boolean_and, 60, :left],
                                     [boolean_or, 50, :right],
                                     [eclipse, 40, :right],
                                     [keyword_rescue, 30, :right], 
                                     [assign, 20, :right],
                                     [op_assign, 20, :right],
                                     [keyword_until, 10, :right], 
                                     [keyword_while, 10, :right], 
                                     [keyword_unless, 10, :right], 
                                     [keyword_if, 10, :right]) 
                                   end
  end
end

require_relative "basic_types"
require_relative "tokens"
require_relative "keywords"

module Parser
  
  #obviously a work in progress !!
  # We "compose" the parser from bits, divide and hopefully conquer
   
  class Composed < Parslet::Parser
    include BasicTypes
    include Tokens
    include Keywords
    
    # Note about the lists (argument and parameter)
    # Beause of the maybe for the comma ...  part , the rules may return either 
    # - a single simple version with one element 
    # a sequence with many element. 
    # This leads to the fact that two transform rules are needed for either 
    rule(:argument_list) {
      left_parenthesis >>
      ((expression.as(:argument) >> (comma >> expression.as(:argument)).repeat(0)).maybe).as(:argument_list) >>
      right_parenthesis
    }

    rule(:function_call) { name.as(:function_call) >> argument_list }

    rule(:assignment) { name.as(:asignee) >> equal_sign >> expression.as(:asigned)  }

    rule(:expression) { conditional | function_call | integer | string | (name >> space? >> equal_sign.absent?) }

    def delimited_expressions( delimit )
      ( space? >> (delimit.absent? >> (assignment | expression)).repeat(1)).as(:expressions) >> delimit
    end
    
    rule(:conditional) {
      keyword_if >> left_parenthesis >> expression.as(:conditional) >> right_parenthesis >>
        delimited_expressions(keyword_else).as(:if_true) >> 
        delimited_expressions(keyword_end).as(:if_false)
    }
    
    rule(:expressions_else)   { delimited_expressions(keyword_else) }
    rule(:expressions_end)    { delimited_expressions(keyword_end) }

    rule(:function_definition) {
      keyword_def >> name.as(:function_definition) >> parmeter_list >> expressions_end
    }

    rule(:parmeter_list) {
      left_parenthesis >>
        ((name.as(:parmeter) >> (comma >> name.as(:parmeter)).repeat(0)).maybe).as(:parmeter_list) >>
      right_parenthesis
    }
    rule(:root){ function_definition | expression | assignment }
  end
end

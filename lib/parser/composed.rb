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
    
    rule(:argument_list) {
      left_parenthesis >>
      ((expression.as(:argument) >> (comma >> expression.as(:argument)).repeat(0)).maybe).as(:argument_list) >>
      right_parenthesis
    }

    rule(:function_call) { name.as(:function_call) >> argument_list }

    rule(:expression) { conditional | function_call | integer | name }

    rule(:conditional) {
      keyword_if >> left_parenthesis >> expression.as(:conditional) >> right_parenthesis >>
        block.as(:if_true) >>
        keyword_else >>
        block.as(:if_false)
    }

    rule(:block)    { left_brace >> expression.as(:block) >> right_brace }

    rule(:function_definition) {
      keyword_def >> name.as(:function_definition) >> parmeter_list >> block
    }

    rule(:parmeter_list) {
      left_parenthesis >>
        ((name.as(:parmeter) >> (comma >> name.as(:parmeter)).repeat(0)).maybe).as(:parmeter_list) >>
      right_parenthesis
    }
    rule(:root){ function_definition.repeat(0) >> expression | expression | argument_list }
  end
end

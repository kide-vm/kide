require_relative "basic_types"
require_relative "tokens"
require_relative "keywords"
require_relative "conditional"
require_relative "expression"
require_relative "function_call"
require_relative "function_definition"
require_relative "operators"

module Parser
  
  # obviously a work in progress !!
  # We "compose" the parser from bits, divide and hopefully conquer
   
  # a note about .maybe : .maybe is almost every respect the same as .repeat(0,1)
  # so either 0, or 1, in other words maybe. Nice feature, but there are strings attached:
  # a maybe removes the 0  a sequence (array) to a single (hash). Thus 2 transformations are needed
  # More work than the prettiness is worth, so only use .maybe on something that does not need capturing

  class Crystal < Parslet::Parser
    include BasicTypes
    include Tokens
    include Keywords
    include Conditional
    include Expression
    include FunctionCall
    include FunctionDefinition
    include Operators

    rule(:root){ (function_definition | expression | operator_expression | function_call).repeat }
  end
end

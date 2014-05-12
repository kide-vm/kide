module Parser
  # Compound types are Arrays and Hashes
  module CompundTypes
    include Parslet

    rule(:array) do
      left_bracket >>
      (  ((operator_expression|value_expression).as(:element) >> space? >>
          (comma >> space? >> (operator_expression|value_expression).as(:element)).repeat(0)).repeat(0,1)).as(:array) >>
          space? >> right_bracket
      end


    rule(:hash_pair)  { basic_type.as(:argument) >> association >> (operator_expression|value_expression).as(:element) }
    rule(:hash)       { left_brace >> ((hash_pair.as(:hash_pair) >> 
                         (comma >> space? >> hash_pair.as(:hash_pair)).repeat(0)).repeat(0,1)).as(:hash)>> 
                         space? >> right_brace }

  end
end
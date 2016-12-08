
# Base class for Expresssion and Statement
module Typed

  class Code

  end

  class Statement < Code
  end
  class Expression < Code
  end

end

require_relative "while_statement"
require_relative "if_statement"
require_relative "return_statement"
require_relative "statements"
require_relative "operator_expression"
require_relative "field_access"
require_relative "call_site"
require_relative "basic_values"
require_relative "assignment"
require_relative "class_statement"
require_relative "function_statement"
require_relative "to_code"

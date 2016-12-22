# Base class for Expresssion and Statement
module Typed

  class Code              ; end
  class Statement < Code  ; end
  class Expression < Code ; end

end

require_relative "tree/while_statement"
require_relative "tree/if_statement"
require_relative "tree/return_statement"
require_relative "tree/statements"
require_relative "tree/operator_expression"
require_relative "tree/field_access"
require_relative "tree/call_site"
require_relative "tree/basic_values"
require_relative "tree/assignment"
require_relative "tree/to_code"

AST::Node.class_eval do

  # def [](name)
  #   #puts self.inspect
  #   children.each do |child|
  #     if child.is_a?(AST::Node)
  #       #puts child.type
  #       if (child.type == name)
  #         return child.children
  #       end
  #     else
  #       #puts child.class
  #     end
  #   end
  #   nil
  # end
  #
  # def first_from( node_name )
  #   from = self[node_name]
  #   return nil unless from
  #   from.first
  # end
end

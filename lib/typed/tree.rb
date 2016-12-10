# Base class for Expresssion and Statement
module Typed

  class Code              ; end
  class Statement < Code  ; end
  class Expression < Code ; end

end

["while_statement", "if_statement" , "return_statement" , "statements",
  "operator_expression" , "field_access" , "call_site" , "basic_values",
  "assignment" , "class_statement" , "function_statement" , "to_code"].each do |code|
    require_relative "tree/" + code
end

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

module Vm
  # Convert ast to vm-values via visitor pattern
  # We do this (what would otherwise seem like foot-shuffling) to keep the layers seperated
  # Ie towards the feature goal of reusing the same parse for several binary outputs 
   
  # scope of the funcitons is thus class scope ie self is the expression and all attributes work
  # gets included into Value
  module Conversion
    def to_value
      cl_name = self.class.name.to_s.split("::").last.gsub("Expression","").downcase
      send "#{cl_name}_value"
    end
    def funcall_value
      FunctionCall.new( name , args.collect{ |a| a.to_value } )
    end
    def string_value
      ObjectReference.new( string )
    end
  end
  
end
require_relative "../parser/nodes"

Parser::Expression.class_eval do
  include Vm::Conversion
end
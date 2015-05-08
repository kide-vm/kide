module Compiler

  def self.compile expression , method
    exp_name = expression.class.name.split("::").last.sub("Expression","").downcase
    #puts "Expression #{exp_name}"
    begin
      self.send "compile_#{exp_name}".to_sym , expression, method
    rescue NoMethodError => e
      puts "no compile method foudn for " + exp_name
      raise e
    end
  end

end

require_relative "compiler/basic_expressions"
require_relative "compiler/callsite_expression"
require_relative "compiler/compound_expressions"
require_relative "compiler/if_expression"
require_relative "compiler/function_expression"
require_relative "compiler/module_expression"
require_relative "compiler/operator_expressions"
require_relative "compiler/return_expression"
require_relative "compiler/while_expression"
require_relative "compiler/expression_list"

module Compiler

  def self.compile expression , method , message
    exp_name = expression.class.split("::").last.sub("Expression","").downcase
    puts "Expression #{exp_name}"
    self.send exp_name.to_sym , method , message
  end

end

require_relative "compiler/basic_expressions"
require_relative "compiler/call_site_expression"
require_relative "compiler/compound_expressions"
require_relative "compiler/if_expression"
require_relative "compiler/function_expression"
require_relative "compiler/module_expression"
require_relative "compiler/operator_expressions"
require_relative "compiler/return_expression"
require_relative "compiler/while_expression"
require_relative "compiler/expression_list"

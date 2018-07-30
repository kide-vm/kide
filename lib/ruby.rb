require "parser/ruby22"
require "ast"

AST::Node.class_eval do
  def first
    children.first
  end
end

require_relative "ruby/statement"
require_relative "ruby/statements"
require_relative "ruby/assignment"
require_relative "ruby/array_statement"
require_relative "ruby/block_statement"
require_relative "ruby/if_statement"
require_relative "ruby/normalizer"
require_relative "ruby/class_statement"
require_relative "ruby/logical_statement"
require_relative "ruby/return_statement"
require_relative "ruby/while_statement"
require_relative "ruby/basic_values"
require_relative "ruby/hash_statement"
require_relative "ruby/method_statement"
require_relative "ruby/ruby_compiler"
require_relative "ruby/call_statement"
require_relative "ruby/send_statement"
require_relative "ruby/yield_statement"
require_relative "ruby/variables"

require_relative "ruby/ruby_compiler"

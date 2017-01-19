require "logging"
require "elf/object_writer"
require "ast"

AST::Node.class_eval do
  def first
    children.first
  end
end

require "salama-object-file"
require "risc"
require "risc/builtin/space"
require "arm/arm_machine"
require "arm/translator"

require "rubyx/ruby_compiler"

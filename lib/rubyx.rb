require "parser/ruby22"
require "ast"

AST::Node.class_eval do
  def first
    children.first
  end
end

require "rx-file"

require_relative "logging"
require_relative "elf/object_writer"
require_relative "risc"
require_relative "arm/arm_machine"
require_relative "arm/translator"
require_relative "common/list"
require_relative "common/statements"
require_relative "vool/vool_compiler"
require_relative "mom/mom"

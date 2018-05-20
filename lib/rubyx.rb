require "parser/ruby22"
require "ast"

AST::Node.class_eval do
  def first
    children.first
  end
end

require "rx-file"

require "util/logging"
require_relative "elf/object_writer"
require_relative "risc"
require_relative "arm/arm_machine"
require_relative "arm/arm_platform"
require_relative "vool/vool_compiler"
require_relative "mom/mom"

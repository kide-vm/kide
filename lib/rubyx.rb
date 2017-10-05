require "parser/ruby22"
require "logging"
require "elf/object_writer"
require "ast"

AST::Node.class_eval do
  def first
    children.first
  end
end

require "rx-file"
require "risc"
require "risc/builtin/space"
require "arm/arm_machine"
require "arm/translator"
require "common"
require "vool"
require "mom"

require 'parslet'

require "logging"
require "elf/object_writer"
require 'salama-reader'
AST::Node.class_eval do
  def first
    children.first
  end
end

require 'parser/transform'
require "salama-object-file"
require "register"
require "register/builtin/space"
require "arm/arm_machine"
require "arm/translator"

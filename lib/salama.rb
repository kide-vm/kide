require 'parslet'

require "stream_reader"
require "elf/object_writer"
require 'salama-reader'
AST::Node.class_eval do
  def each
    children.each do |child|
      yield child
    end
  end
  def first
    children.first
  end
end

require 'parser/transform'
require "salama-object-file"
require "virtual"
require "register/register"
require "register/builtin/object"
require "arm/arm_machine"

require_relative '../helper'
require 'parslet/convenience'

module VirtualHelper
  # need a code generator, for arm 
  def setup
#    @object_space = Boot::BootSpace.new "Arm"
  end

  def check 
    parser  = Parser::Crystal.new
    syntax  = parser.parse_with_debug(@string_input)
    parts   = Parser::Transform.new.apply(syntax)
    machine = Virtual::Machine.new
    expressions = parts.compile(machine.bindings)
    assert_equal @output , expressions
  end
  
end

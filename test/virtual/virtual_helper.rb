require_relative '../helper'
require 'parslet/convenience'
require "yaml"

module VirtualHelper
  # need a code generator, for arm 
  def setup
#    @object_space = Boot::BootSpace.new "Arm"
  end

  def check 
    parser  = Parser::Kide.new
    syntax  = parser.parse_with_debug(@string_input)
    parts   = Parser::Transform.new.apply(syntax)
    machine = Virtual::Machine.new
    main = Virtual::MethodDefinition.main
    expressions = parts.compile(machine.frame , main )
    should = YAML.load(@output.gsub("RETURN_MARKER" , "\n"))
    assert_equal should , expressions , expressions.to_yaml.gsub("\n" , "RETURN_MARKER") +  "\n" + expressions.to_yaml 
  end
  
end

require_relative '../helper'
require 'parslet/convenience'
require "yaml"

module VirtualHelper
  # need a code generator, for arm 
  def setup
#    @object_space = Boot::BootSpace.new "Arm"
  end

  def check
    machine = Virtual::Machine.boot
    expressions = machine.compile_main @string_input
    should = YAML.load(@output.gsub("RETURN_MARKER" , "\n"))
    assert_equal should , expressions , expressions.to_yaml.gsub("\n" , "RETURN_MARKER") +  "\n" + Sof::Writer.write(expressions)
    puts ""
    puts Sof::Writer.write(expressions)
  end
  
end

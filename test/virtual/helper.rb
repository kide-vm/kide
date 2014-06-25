require_relative '../helper'
require 'parslet/convenience'

module VmHelper
  # need a code generator, for arm 
  def setup
    @object_space = Boot::BootSpace.new "Arm"
  end

  def parse 
    parser  = Parser::Crystal.new
    syntax  = parser.parse_with_debug(@string_input)
    parts   = Parser::Transform.new.apply(syntax)

    parts.each_with_index do |part,index|
      expr    = part.compile( @object_space.context )
    end

  end
  
end

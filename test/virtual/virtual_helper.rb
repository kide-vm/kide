require_relative '../helper'
require 'parslet/convenience'
require "yaml"

module VirtualHelper
  # need a code generator, for arm
  def setup
#    @object_space = Boot::Space.new "Arm"
  end

  def check
    machine = Virtual::Machine.reboot
    expressions = machine.compile_main @string_input
    is = Sof::Writer.write(expressions)
    #puts is
    is.gsub!("\n" , "*^*")
    assert_equal is , @output
  end

end

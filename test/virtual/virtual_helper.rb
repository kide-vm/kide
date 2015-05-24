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
    if( expressions.first.is_a? Parfait::Method )
      # stops the whole objectspace beeing tested
      # with the class comes superclass and all methods
      expressions.first.instance_variable_set :@for_class , nil
    end
    if( expressions.first.is_a? Virtual::Self )
      # stops the whole objectspace beeing tested
      # with the class comes superclass and all methods
      expressions.first.type.instance_variable_set :@of_class , nil
    end
    is = Sof::Writer.write(expressions)
    #puts is
    is.gsub!("\n" , "*^*")
    assert_equal is , @output
  end

end

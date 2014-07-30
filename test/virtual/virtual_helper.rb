require_relative '../helper'
require 'parslet/convenience'

module VirtualHelper
  # need a code generator, for arm 
  def setup
#    @object_space = Boot::BootSpace.new "Arm"
  end

  def check
    machine = Virtual::Machine.new
    parts = machine.read @string_input
    main = Virtual::MethodDefinition.main
    expressions = parts.compile( main, machine.message )
    should = YAML.load(@output.gsub("RETURN_MARKER" , "\n"))
    assert_equal should , expressions , expressions.to_yaml.gsub("\n" , "RETURN_MARKER") +  "\n" + expressions.to_yaml 
  end
  
end

require "yaml"   # not my first choice, but easy with graphs
# for readability of the yaml output :next of instructions last

Psych::Visitors::YAMLTree.class_eval do
  private
  def dump_ivars target
    ivars = find_ivars target
    ivars << :@next if ivars.delete(:@next)
    ivars.each do |iv|
      @emitter.scalar("#{iv.to_s.sub(/^@/, '')}", nil, nil, true, false, Psych::Nodes::Scalar::ANY)
      accept target.instance_variable_get(iv)
    end
  end
end

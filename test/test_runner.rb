require_relative 'helper'
require "yaml"
class TestRunner < MiniTest::Test

  # this creates test methods dynamically , one for each file in runners directory
  def self.runnable_methods
    methods = []
    Dir[File.join(File.dirname(__FILE__) , "runners" , "*.rb")].each do |file|
      meth =  File.basename(file).split(".").first
      name = "test_#{meth}"
      methods << name
      self.send(:define_method, name ) {
        execute file
      }
    end
    methods
  end

  def execute file
    string = File.read(file)
    syntax    = Parser::Composed.new.parse(string)
    tree      = Parser::Transform.new.apply(syntax)
    #transform
    # write
    #link
    # execute
    # check result ?
    program = Vm::Program.new
    expression = tree.to_value
    compiled = expression.compile( program.context )
    # do some stuff with mains and what not ??
    program.wrap_as_main compiled
    puts program.to_yaml
    program.verify
    puts program.to_yaml
  end

end
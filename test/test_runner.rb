require_relative 'helper'
require "yaml"
require "parslet/convenience"
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
    parser = Parser::Salama.new
    object_space = Register::Program.new "Arm"
    syntax  = parser.parse_with_debug(string)
    assert syntax
    parts   = Parser::Transform.new.apply(syntax)
    # file is a list of statements, all but the last must be a function
    # and the last is wrapped as a main
    parts.each_with_index do |part,index|
      if index == (parts.length - 1)
        expr    = part.compile( program.context )
      else
        expr    = part.compile( program.context )
        raise "should be function definition for now" unless expr.is_a? Register::Function
      end
    end

    #object writer takes machine
    writer = Elf::ObjectWriter.new(program , Elf::Constants::TARGET_ARM)

    writer.save(file.gsub(".rb" , ".o"))

#    puts program.to_yaml
  end

end

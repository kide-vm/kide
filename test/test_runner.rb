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
    parser = Parser::Crystal.new
    program = Vm::Program.new "Arm"
    syntax  = parser.parse_with_debug(string)
    parts   = Parser::Transform.new.apply(syntax)
    # file is a list of expressions, all but the last must be a function
    # and the last is wrapped as a main
    parts.each_with_index do |part,index|
      if index == (parts.length - 1)
        expr    = part.compile( program.context , program.main )
      else
        expr    = part.compile( program.context ,  nil )
        raise "should be function definition for now" unless expr.is_a? Vm::Function
        program.add_function expr
      end
    end

    program.link_at( 0 , program.context )
    
    binary = program.assemble(StringIO.new )

    writer = Elf::ObjectWriter.new(Elf::Constants::TARGET_ARM)

    assembly = program.assemble(StringIO.new)

    writer.set_text assembly.string
    writer.save(file.gsub(".rb" , ".o"))

#    puts program.to_yaml
  end

end
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
    parts = string.split "SPLIT"
    parts.each_with_index do |part,index|
      puts "parsing #{index}=#{part}"
      syntax  = parser.parse_with_debug(part)
      funct   = Parser::Transform.new.apply(syntax)
      expr    = funct.compile( program.context )
      if index = parts.length
        program.main = expr
      else
        raise "should be function definition for now" unless expr.is_a? Function
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
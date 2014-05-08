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
    parser = Parser::Composed.new
    syntax    = parser.function_definition.parse_with_debug(string)
    program = Vm::Program.new "Arm"
    main      = Parser::Transform.new.apply(syntax)


    program.main = main.compile( program.context )

    program.link_at( 0 , program.context )
    
    binary = program.assemble(StringIO.new )

    writer = Elf::ObjectWriter.new(Elf::Constants::TARGET_ARM)

    assembly = program.assemble(StringIO.new)

    writer.set_text assembly.string
    writer.save(file.gsub(".rb" , ".o"))

    puts program.to_yaml
  end

end
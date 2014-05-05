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
    main      = Parser::Transform.new.apply(syntax)
    
    program = Vm::Program.new "Arm"

    program.main = main.compile( program.context )

    program.link_at( 0 , program.context )
    
    binary = program.assemble(StringIO.new )

    writer = Elf::ObjectWriter.new(Elf::Constants::TARGET_ARM)

    assembly = program.assemble(StringIO.new)

    writer.set_text assembly
    writer.save("#{file}_test.o")    

    puts program.to_yaml
  end

end
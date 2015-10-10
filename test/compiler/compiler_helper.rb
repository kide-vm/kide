require_relative '../helper'
require 'parslet/convenience'

module CompilerHelper

  Phisol::Compiler.class_eval do
    def set_main
      @method = Virtual.machine.space.get_main
    end
  end
  def check
    machine = Virtual.machine.boot
    parser = Parser::Salama.new
    parser = parser.send @root
    syntax  = parser.parse_with_debug(@string_input)
    parts = Parser::Transform.new.apply(syntax)
    #puts parts.inspect
    compiler = Phisol::Compiler.new
    compiler.set_main
    produced = compiler.process( parts )
    produced = [produced] unless produced.is_a? Array
    assert @output , "No output given"
    assert_equal  produced.length, @output.length , "Block length"
    produced.each_with_index do |b,i|
      codes = @output[i]
      assert_equal codes ,  b.class ,  "Class #{i} "
    end
  end

end

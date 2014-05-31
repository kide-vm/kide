require_relative '../helper'
require 'parslet/convenience'

#test the generation of code fragments. 
# ie parse                assumes @string_input
#   compile
#   assemble/write        assume a @should array with the bytes in it

# since the bytes are store, the test can be run on any machine.

# but to get the bytes, one needs to link and run the object file to confirm correctness (to be automated)

module Fragments
  # need a code generator, for arm 
  def setup
    @object_space = Vm::BootSpace.new "Arm"
  end

  def parse 
    parser = Parser::Crystal.new
    syntax  = parser.parse_with_debug(@string_input)
    parts   = Parser::Transform.new.apply(syntax)
    # file is a list of expressions, all but the last must be a function
    # and the last is wrapped as a main
    parts.each_with_index do |part,index|
      if index == (parts.length - 1)
        expr    = part.compile( @object_space.context , @object_space.main )
      else
        expr    = part.compile( @object_space.context ,  nil )
        raise "should be function definition for now" unless expr.is_a? Vm::Function
      end
    end
  end

  # helper to write the file
  def write name
    writer = Elf::ObjectWriter.new(@object_space , Elf::Constants::TARGET_ARM)
    assembly = writer.text
    # use this for getting the bytes to compare to :  
    #puts assembly
    writer.save("#{name}.o")
    assembly.text.bytes.each_with_index do |byte , index|
      is = @should[index]
      assert_equal  Fixnum , is.class , "@#{index.to_s(16)} = #{is}"
      assert_equal  byte , is  , "@#{index.to_s(16)} #{byte.to_s(16)} != #{is.to_s(16)}"
    end
    if( RbConfig::CONFIG["build_cpu"] == "arm")
      system "ld -N #{name}.o"
      result = %x[./a.out]
      assert_equal @output , result
    end
  end
end

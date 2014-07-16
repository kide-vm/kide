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
    @object_space = Boot::BootSpace.new "Arm"
  end

  def parse 
    parser = Parser::Kide.new
    syntax  = parser.parse_with_debug(@string_input)
    parts   = Parser::Transform.new.apply(syntax)
    # file is a list of expressions, all but the last must be a function
    # and the last is wrapped as a main
    parts.each_with_index do |part,index|
      if part.is_a? Ast::FunctionExpression
        expr    = part.compile( @object_space.context )
      else
        puts part.inspect if part.is_a? Hash
        expr    = part.compile( @object_space.context )
      end
    end
  end

  # helper to write the file
  def write name
    writer = Elf::ObjectWriter.new(@object_space , Elf::Constants::TARGET_ARM)
    assembly = writer.text
    writer.save("#{name}.o")    
    function = @object_space.classes[@target[0]]
    assert function , "no class #{@target[0]}"
    function = function.get_function(@target[1])
    assert function , "no function #{@target[1]}  for class #{@target[0]}"
    io = StringIO.new
    function.assemble io
    assembly = io.string
    # use this for getting the bytes to compare to :  
    puts bytes(assembly)
    assembly.bytes.each_with_index do |byte , index|
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
  def bytes string
    "[" + string.bytes.collect{|b| "0x"+ b.to_s(16)}.join(",") + "]"
  end
  
end

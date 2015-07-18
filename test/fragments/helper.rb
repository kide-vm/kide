require_relative '../helper'

# simple tests to check parsing pworks and the first classes come out right.
#
# build up from small to check larger expressions are correct

module Fragments

  def check
    expressions = Virtual.machine.boot.compile_main @string_input
    @expect.each_with_index do | should , i |
      assert_equal should , expressions[i].class
    end
  end

  # helper to write the file
  def write name
    writer = Elf::ObjectWriter.new(@object_machine , Elf::Constants::TARGET_ARM)
    assembly = writer.text
    writer.save("#{name}.o")
    function = @object_machine.classes[@target[0]]
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

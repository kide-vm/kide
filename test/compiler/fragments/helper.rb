require_relative '../../helper'

# simple tests to check parsing pworks and the first classes come out right.
#
# build up from small to check larger statements are correct

module Fragments

  def check
    machine = Virtual.machine.boot
    machine.parse_and_compile @string_input
    produced = Virtual.machine.space.get_main.source
    assert @expect , "No output given"
    assert_equal @expect.length ,  produced.blocks.length , "Block length"
    produced.blocks.each_with_index do |b,i|
      codes = @expect[i]
      assert codes , "No codes for block #{i}"
      assert_equal b.codes.length , codes.length , "Code length for block #{i+1}"
      b.codes.each_with_index do |c , ii |
        assert_equal codes[ii] ,  c.class ,  "Block #{i+1} , code #{ii+1}"
      end
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

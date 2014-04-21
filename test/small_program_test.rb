require_relative 'helper'

# test the generation of a whole program
# not many asserts, but assume all is  well (ho ho)
# linking and running does not produce seqmentation fault, ie it works
# should really thiink about more asserts (but currently no way to execute as still running on mac )
#    (have to fix the int being used in code generation as ruby int is only 31 bits, and that wont do)

class TestSmallProg < MiniTest::Test
  # need a code generator, for arm 
  def setup
    @generator = Asm::Arm::CodeGenerator.new
  end

  def test_generate_small
    @generator.instance_eval {
      mov r0, 5                #1
      loop_start = label!
      subs r0, r0, 1          #2
      bne loop_start          #3
    	mov r7, 1               #4
    	swi 0                   #5  5 instructions
    }
    write( 5 , "small" )
  end
  
  def test_extern
    @generator.instance_eval {
      mov r0 , 50             #1
      push lr                 #2
      bl extern(:putchar)     #3
    	pop pc                  #4 
      mov r7, 1               #5
    	swi 0                   #6  6 instructions
    }
    #this actually seems to get an extern symbol out there and linker is ok (but doesnt run, hmm)
    @generator.relocations.each { |reloc|
      #puts "reloc #{reloc.inspect}"
      writer.add_reloc_symbol reloc.label.name.to_s
    }
    write( 6 , "extern")
  end

  #helper to write the file
  def write len ,name
    writer = Asm::ObjectWriter.new(Elf::Constants::TARGET_ARM)
    assembly = @generator.assemble
    assert_equal len * 4 , assembly.length 
    writer.set_text assembly
    writer.save("#{name}_test.o")    
  end
end

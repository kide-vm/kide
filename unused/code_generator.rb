require "asm/arm/code_generator"

if (__FILE__ == $0)
  gen = Asm::Arm::CodeGenerator.new

  gen.instance_eval {
    mov r0, 5
    loop_start = label
    loop_start.set!
    subs r0, r0, 1
    bne loop_start
    bx lr
  }

  require 'asm/object_writer'
  writer = Asm::ObjectWriter.new(Elf::Constants::TARGET_ARM)
  writer.set_text gen.assemble


  begin
    writer.save('arm_as_generated.o')
  rescue => err
    puts 'as: cannot save output file: ' + err.message
    exit
  end

end

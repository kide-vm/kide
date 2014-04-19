require_relative 'helper'
require "asm/arm/code_generator"

# try  to test that the generation of basic instructions works
# one instruction at a time, reverse testing from objdump --demangle -Sfghxp
# tests are named as per assembler code, ie test_mov testing mov instruction
#  adc add and bic eor orr rsb rsc sbc sub mov mvn cmn cmp teq tst b bl bx swi strb

class TestArmAsm < MiniTest::Test
  # need a code generator, for arm 
  def setup
    @generator = Asm::Arm::CodeGenerator.new
  end

  # code is what the generator spits out, at least one instruction worth (.first)
  # the op code is wat was witten as assembler in the first place and the binary result
  # is reversed and in 4 bytes as ruby can only do 31 bits and so we can't test with just one int (?)
  def assert_code code , op , should 
    assert_equal op ,  code.opcode
    binary = @generator.assemble
    assert_equal 4 , binary.length
    index = 0
    binary.each_byte do |byte |
      assert_equal should[index] , byte , "byte #{index} 0x#{should[index].to_s(16)} != 0x#{byte.to_s(16)}"
      index += 1
    end
  end
  def test_adc
    code = @generator.instance_eval { adc	r1, r3, r5}.first
    assert_code code , :adc , [0x05,0x10,0xa3,0xe0] #e0 a3 10 05
  end
  def test_add
    code = @generator.instance_eval { add	r1 , r1, r3}.first
    assert_code code , :add , [0x03,0x10,0x81,0xe0] #e0 81 10 03
  end
  def test_and # inst eval doesn't really work with and
    code = @generator.and(	[:reg , 'r1'] , [:reg , 'r2'] , [:reg , 'r3']).first
    assert_code code , :and , [0x03,0x10,0x02,0xe0] #e0 01 10 03
  end
  def test_b
    # the address is what an assembler calculates (a signed number for the amount of instructions), 
    # ie the relative (to pc) address -8 (pipeline) /4 so save space
    # so the cpu adds the value*4 and starts loading that (load, decode, execute)
    code = @generator.instance_eval { b	-1 }.first #this jumps to the next instruction
    assert_code code , :b , [0xff,0xff,0xff,0xea] #ea ff ff fe
  end
  def test_bl #see comment above. bx not implemented (as it means into thumb, and no thumb here)
    code = @generator.instance_eval { bl	-1 }.first #this jumps to the next instruction
    assert_code code , :bl , [0xff,0xff,0xff,0xeb] #ea ff ff fe
  end
  def test_bic
    code = @generator.instance_eval { bic	r2 , r2 , r3 }.first
    assert_code code , :bic , [0x03,0x20,0xc2,0xe1] #e3 c2 20 44
  end
  def test_cmn
    code = @generator.instance_eval { cmn	r1 , r2  }.first
    assert_code code , :cmn , [0x02,0x00,0x71,0xe1] #e1 71 00 02
  end
  def test_cmp
    code = @generator.instance_eval { cmp	r1 , r2  }.first
    assert_code code , :cmp , [0x02,0x00,0x51,0xe1] #e1 51 00 02
  end
  def test_eor
    code = @generator.instance_eval { eor	r2 , r2 , r3 }.first
    assert_code code , :eor , [0x03,0x20,0x22,0xe0] #e0 22 20 03
  end
  def test_ldr
    code = @generator.instance_eval { ldr r0, r0 }.first
    assert_code code, :ldr ,  [0x00,0x00,0x90,0xe5] #e5 90 00 00
  end
  def test_ldrb
    code = @generator.instance_eval { ldrb r0, r0 }.first
    assert_code code, :ldrb ,  [0x00,0x00,0xd0,0xe5] #e5 d0 00 00
  end
  def test_orr
    code = @generator.instance_eval { orr	r2 , r2 , r3 }.first
    assert_code code , :orr , [0x03,0x20,0x82,0xe1] #e1 82 20 03
  end
  def test_rsb
    code = @generator.instance_eval { rsb	r1 , r2 , r3 }.first
    assert_code code , :rsb , [0x03,0x10,0x62,0xe0]#e0 62 10 03
  end
  def test_rsc
    code = @generator.instance_eval { rsc	r2 , r3 , r4 }.first
    assert_code code , :rsc , [0x04,0x20,0xe3,0xe0]#e0 e3 20 04
  end
  def test_sbc
    code = @generator.instance_eval { sbc	r3, r4 , r5 }.first
    assert_code code , :sbc , [0x05,0x30,0xc4,0xe0]#e0 c4 30 05
  end
  def test_str
    code = @generator.instance_eval { str r0, r0 }.first
    assert_code code, :str ,  [0x00,0x00,0x80,0xe5] #e5 81 00 00
  end
  def test_strb
    code = @generator.instance_eval { strb r0, r0 }.first
    assert_code code, :strb ,  [0x00,0x00,0xc0,0xe5] #e5 c0 00 00
  end
  def test_sub
    code = @generator.instance_eval { sub r2, r0, 1 }.first
    assert_code code, :sub ,  [0x01,0x20,0x40,0xe2] #e2 40 20 01 
  end
  def test_swi
    code = @generator.instance_eval { swi	0x05 }.first
    assert_code code , :swi , [0x05,0x00,0x00,0xef]#ef 00 00 05
  end
  def test_teq
    code = @generator.instance_eval{	teq r1 , r2}.first
    assert_code code , :teq , [0x02,0x00,0x31,0xe1] #e1 31 00 02
  end
  def test_tst
    code = @generator.instance_eval{	tst r1 , r2}.first
    assert_code code , :tst , [0x02,0x00,0x11,0xe1] #e1 11 00 02
  end
  def test_mov
    code = @generator.instance_eval { mov r0, 5 }.first
    assert_code code , :mov , [0x05,0x00,0xa0,0xe3] #e3 a0 10 05
  end
  def test_mvn
    code = @generator.instance_eval { mvn r1, 5 }.first
    assert_code code , :mvn , [0x05,0x10,0xe0,0xe3] #e3 e0 10 05
  end
  def saved_other
    @generator.instance_eval do
      mov r0, 5
      loop_start = label!
      subs r0, r0, 1
      bne loop_start
      bx lr
    end
  end
end

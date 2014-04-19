Assembler in Ruby
=================

Supporting arm, but aimed quite specifically at raspberry pi, arm v7, floating point included

Outputs Elf object files, with relocation support.

Constant table support exists but isn't very good. Some addressing modes
are not supported or only partially supported.

Supported (pseudo)instructions:

- adc, add, and, bic, eor, orr, rsb, rsc, sbc, sub, cmn, cmp, teq, tst,
  mov, mvn, strb, str, ldrb, ldr, push, pop, b, bl, bx, swi
- Conditional versions of above

Thanks to Cyndis for starting this arm/elf project in the first place: https://github.com/cyndis/as
 

require 'asm/assembler'

module Asm
  module Arm
    
    # Relocation constants
    # Note that in this assembler, a relocation simply means any
    # reference to a label that can only be determined at assembly time
    # or later (as in the normal meaning)
  
    R_ARM_PC24 = 0x01
    R_ARM_ABS32 = 0x02
  
    # Unofficial (cant be used for extern relocations)
    R_ARM_PC12 = 0xF0
  
    # TODO actually find the closest somehow
    def self.closest_addrtable(as)
      as.objects.find do |obj|
        obj.is_a?(Asm::Arm::AddrTableObject)
      end || (raise Asm::AssemblyError.new('could not find addrtable to use', nil))
    end

    def self.write_resolved_relocation(io, addr, type)
      case type
      when R_ARM_PC24
        diff = addr - io.tell - 8
        if (diff.abs > (1 << 25))
          raise Asm::AssemblyError.new('offset too large for R_ARM_PC24 relocation', nil)
        end
        packed = [diff >> 2].pack('l')
        io << packed[0,3]
      when R_ARM_ABS32
        packed = [addr].pack('l')
        io << packed
      when R_ARM_PC12
        diff = addr - io.tell - 8
        if (diff.abs > 2047)
          raise Asm::AssemblyError.new('offset too large for R_ARM_PC12 relocation', nil)
        end
      
        val = diff.abs
        sign = (diff>0)?1:0
      
        curr = io.read_uint32
        io.seek(-4, IO::SEEK_CUR)
      
        io.write_uint32 (curr & ~0b00000000100000000000111111111111) | 
                        val | (sign << 23)
      else
        raise 'unknown relocation type'
      end
    end
  end
end


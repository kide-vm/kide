require 'intel/special_register'

module Intel
  ##
  # Command is a potential command you can call. It has an
  # opcode (eg: MOV) and the memory format that it outputs as
  # (opcodes) as well as the kinds of parameters it takes and the
  # processor types that support the command.

  # Commands are parsed from the assembler.txt file

  class Command
    attr_accessor :opcode, :opcodes, :processors , :parameters

    def initialize opcode , opcodes , processors , parameters = nil
      @opcode = opcode 
      @opcodes = opcodes 
      @processors = processors
      @parameters = parameters
    end
    
    def dup
      x            = super
      x.parameters = x.parameters.dup
      x.opcodes    = x.opcodes.dup
      x
    end

    # TODO: learn this better, and figure out why not polymorphic ==
    def parameter_matches a, b
      return false if String === b

      if a.is_a?(Register) && b.is_a?(Register) then
        return a.bits == b.bits && (b.id.nil? || a.id == b.id)
      end

      if a.is_a?(Address) && b.is_a?(Address) then
        return ! b.offset? || a.offset?
      end

      if a.is_a?(SpecialRegister) && b.is_a?(SpecialRegister) then
        return a.class == b.class && (b.id.nil? || a.id == b.id)
      end

      return false unless b.is_a?(Immediate)

      if a.is_a? Integer then
        return (b.value && b.value == a) || b.bits.nil? || a < (2 ** b.bits)
      end

      if a.is_a? Label then
        return (a.is_a?(FutureLabel) && a.position.nil? )? b.bits == a.machine.bits :
          a.bits <= (b.bits || a.machine.bits)
      end

      false
    end

    def instruction_applies? instruction
      return false if instruction.opcode          != self.opcode
      return false if instruction.parameters.size != self.parameters.size

      instruction.parameters.zip(self.parameters).all? { |a, b|
        self.parameter_matches a, b
      }
    end

    def to_parameter parameter
      case parameter
      when 'r/m8'          then return parameter # "Expanded by the parser"
      when 'r/m16'         then return parameter # "Expanded by the parser"
      when 'r/m32'         then return parameter # "Expanded by the parser"
      when 'r/m64'         then return parameter # "Expanded by the parser"
      when 'TO fpureg'     then return parameter # "Fixed in nasm_fixes"
      when 'SHORT imm'     then return parameter # "Fixed in nasm_fixes"
      when 'FAR mem'       then return parameter # "Fixed in nasm_fixes"
      when 'FAR mem16'     then return parameter # "Fixed in nasm_fixes"
      when 'FAR mem32'     then return parameter # "Fixed in nasm_fixes"
      when 'NEAR imm'      then return parameter # "Fixed in nasm_fixes"
      when 'imm:imm16'     then return parameter # "Fixed in nasm_fixes"
      when 'imm:imm32'     then return parameter # "Fixed in nasm_fixes"
      when '1'             then return Immediate.new(1)
      when 'AL'            then return Register.new(nil, 0, 8)
      when 'AX'            then return Register.new(nil, 0, 16)
      when 'EAX'           then return Register.new(nil, 0, 32)
      when 'CL'            then return Register.new(nil, 1, 8)
      when 'CX'            then return Register.new(nil, 1, 16)
      when 'ECX'           then return Register.new(nil, 1, 32)
      when 'DL'            then return Register.new(nil, 2, 8)
      when 'DX'            then return Register.new(nil, 2, 16)
      when 'EDX'           then return Register.new(nil, 2, 32)
      when 'BL'            then return Register.new(nil, 3, 8)
      when 'BX'            then return Register.new(nil, 3, 16)
      when 'EBX'           then return Register.new(nil, 3, 32)
      when 'ES'            then return SegmentRegister.new(nil, 0)
      when 'CS'            then return SegmentRegister.new(nil, 1)
      when 'SS'            then return SegmentRegister.new(nil, 2)
      when 'DS'            then return SegmentRegister.new(nil, 3)
      when 'FS'            then return SegmentRegister.new(nil, 4)
      when 'GS'            then return SegmentRegister.new(nil, 5)
      when 'imm'           then return Immediate.new
      when 'imm8'          then return Immediate.new(8)
      when 'imm16'         then return Immediate.new(16)
      when 'imm32'         then return Immediate.new(32)
      when 'segreg'        then return SegmentRegister.new
      when 'reg'           then return Register.new
      when 'reg8'          then return Register.new(nil,nil,8)
      when 'reg16'         then return Register.new(nil,nil,16)
      when 'reg32'         then return Register.new(nil,nil,32)
      when 'mem'           then return Address.new(false, 4)
      when 'mem8'          then return Address.new(false, 8)
      when 'mem16'         then return Address.new(false, 16)
      when 'mem32'         then return Address.new(false, 32)
      when 'mem64'         then return Address.new(false, 64)
      when 'mem80'         then return Address.new(false, 80)
      when 'memoffs8'      then return Address.new(true, 8)
      when 'memoffs16'     then return Address.new(true, 16)
      when 'memoffs32'     then return Address.new(true, 32)
      when 'fpureg'        then return FPURegister.new
      when /ST(.*)/        then return FPURegister.new(nil,$1.to_i)
      when 'mmxreg'        then return MMXRegister.new
      when /MM(.*)/        then return MMXRegister.new(nil,nil,$1.to_i)
      when 'CR0/2/3/4'     then return ControlRegister.new
      when 'DR0/1/2/3/6/7' then return DebugRegister.new
      when 'TR3/4/5/6/7'   then return TestRegister.new
      else
        warn "unknown parameter: #{parameter.inspect}"
        return parameter
      end
    end

    def initialize_parameters params
      self.parameters = params.split(/,/).map { |s| self.to_parameter s }
    end

    def assemble instruction
      stream = []

      opcodes.each_with_index do |each, index|
        self.execute_instruction_position_on(each, instruction,
                                             (index + 1) / opcodes.size, stream)
      end

      stream
    end

    def execute_instruction_position_on(byte, instruction, position, stream)
      case byte
      when 'a16', 'a32' then
        raise "not done yet"
      when 'o16' then
        return self.align16_on(instruction, stream)
      when 'o32' then
        return self.align32_on(instruction, stream)
      when 'ib' then
        return stream.push_B(instruction.get_immediate)
      when 'iw' then
        return stream.push_W(instruction.get_second_immediate) if position == 1
        return stream.push_W(instruction.get_immediate)
      when 'id' then
        return stream.push_D(instruction.get_second_immediate) if position == 1
        return stream.push_D(instruction.get_immediate)
      when 'rb' then
        return self.relative_b_on(instruction, stream)
      when 'rw' then
        return self.relative_w_on(instruction, stream)
      when 'rw/rd' then
        return self.relative_w_on(instruction, stream) if
          instruction.machine.bits == 16
        return self.relative_d_on(instruction, stream)
      when 'rd' then
        return self.relative_d_on(instruction, stream)
      when 'ow' then
        raise byte
        # [^stream push_W: instruction get_address offset].
      when 'od' then
        raise byte
        # [^stream push_D: instruction get_address offset].
      when 'ow/od' then
        if instruction.machine.bits == 16 then
          stream.push_W instruction.get_address.offset
        end

        return stream.push_D(instruction.get_address.offset)
      when /^\/(.*)/ then
        return self.modrm_instruction_on($1, instruction, stream)
      end

      number = byte.hex
      number += instruction.parameters[parameters.first.id ? 1 : 0].id if
        byte =~ /r$/
      stream << number
    end

    ##
    # If we get here, there will be at least two parameters to combine
    # a memory address with a register or a register with a register"

    def modrm_r_on instruction, stream
      address, register = instruction.first, instruction.second
      swap = false # TODO: this can be 1 call at the bottom

      if instruction.first.is_a?(Register) && instruction.second.is_a?(Register) then
        if parameters.first.is_a?(MemoryRegister) then
          return instruction.first.push_mod_rm_on(instruction.second, stream)
        else
          return instruction.second.push_mod_rm_on(instruction.first, stream)
        end
      end

      if instruction.first.is_a?(SpecialRegister) then
        return instruction.second.push_mod_rm_on(instruction.first, stream)
      end

      if instruction.second.is_a?(SpecialRegister) then
        return instruction.first.push_mod_rm_on(instruction.second, stream)
      end

      address, register = if instruction.first.is_a?(Register) && instruction.second.respond_to?(:push_mod_rm_on) then
                            [instruction.second, instruction.first]
                          else
                            [instruction.first, instruction.second]
                          end

      address.push_mod_rm_on register, stream
    end

    def align16_on instruction, stream
      stream << 0x66 if instruction.machine.bits != 16
    end

    def relative_x_on instruction, stream, msg, dist
      offset = instruction.first
      offset = offset.offset if offset.is_a?(Address) && offset.offset?

      if offset.is_a? Label then
        if (offset.is_a?(FutureLabel) && offset.position.nil? ) then
          offset.add instruction.machine.stream.size
          return stream.send(msg, dist)
        end
        offset = offset.position
      end

      stream.send(msg, -(instruction.machine.stream.size - offset + dist))
    end

    def relative_b_on instruction, stream
      relative_x_on instruction, stream, :push_B, 2
    end

    def relative_d_on instruction, stream
      relative_x_on instruction, stream, :push_D, 5
    end

    def relative_w_on instruction, stream
      relative_x_on instruction, stream, :push_W, 3
    end

    def modrm_n_instruction_on id, instruction, stream
      instruction.first.push_mod_rm_on Register.new(instruction.machine, id, instruction.first.bits), stream
    end

    def align32_on instruction, stream
      stream << 0x67 if instruction.machine.bits != 32
    end

    def modrm_instruction_on byte, instruction, stream
      if byte == "r" then
        self.modrm_r_on instruction, stream
      else
        self.modrm_n_instruction_on byte.to_i, instruction, stream
      end
    end
  end
end
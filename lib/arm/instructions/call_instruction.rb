module Arm
  # There are only three call instructions in arm branch (b), call (bl) and syscall (swi)

  # A branch could be called a jump as it has no notion of returning

  # The pc is put into the link register to make a return possible
  # a return is affected by moving the stored link register into the pc, effectively a branch

  # swi (SoftWareInterrupt) or system call is how we call the kernel.
  # in Arm the register layout is different and so we have to place the syscall code into register 7
  # Riscs 0-6 hold the call values as for a normal c call
  class CallInstruction < Instruction
    attr_reader :first

    def initialize(first, attributes)
      super(nil, nil)
      @attributes = attributes
      raise "no target" if first.nil?
      @first = first
      opcode = @attributes[:opcode].to_s
      if opcode.length == 3 and opcode[0] == "b"
        @attributes[:condition_code] = opcode[1,2].to_sym
        @attributes[:opcode] = :b
      end
      if opcode.length == 6 and opcode[0] == "c"
        @attributes[:condition_code] = opcode[4,2].to_sym
        @attributes[:opcode] = :call
      end
      @attributes[:update_status] = 0
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
    end

    def assemble(io)
      case @attributes[:opcode]
      when :b, :call
        handle_call(io)
      when :swi
        handle_swi(io)
      else
        raise "Should not be the case #{inspect}"
      end
    end

    def handle_call(io)
      case @first
      when Risc::Label
        # relative addressing for jumps/calls
        # but because of the arm "theoretical" 3- stage pipeline,
        # we have to subtract 2 words (fetch/decode)
        arg =  Risc::Position.get(@first) - Risc::Position.get(self) - 8
      when Parfait::BinaryCode
        # But, for methods, this happens to be the size of the object header,
        # so there it balances out, but not blocks
        # have to use the code, not the method object for methods
        f_pos = Risc::Position.get(@first)
        arg =  f_pos - Risc::Position.get(self)
      else
        arg = @first
      end
      write_call(arg, io)
    end

    def write_call(arg,io)
      raise "else not Attributed arg =\n#{arg.to_s[0..1000]}: #{inspect[0..1000]}" unless (arg.is_a?(Numeric))
      val = (arg >> 2) & 0xFFFFFF
      raise "too big #{val}" if (val & 0xFFFFFFFF000000) != 0
      val |= shift(op_bit_code ,  24)
      val |= shift(COND_CODES[@attributes[:condition_code]] ,  28)
      io.write_unsigned_int_32( val )
    end

    def handle_swi(io)
      arg = @first
      raise "expected literal not #{arg} #{inspect}" unless (arg.is_a?(Numeric))
      val = arg & 0xFFFFFF
      val |= shift(0b1111 ,  24)
      val |= shift(COND_CODES[@attributes[:condition_code]] ,  28)
      io.write_unsigned_int_32 val
    end

    def to_s
      "#{opcode} #{@first} #{super}"
    end
  end
end

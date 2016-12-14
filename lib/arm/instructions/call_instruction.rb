module Arm
  # There are only three call instructions in arm branch (b), call (bl) and syscall (swi)

  # A branch could be called a jump as it has no notion of returning

  # The pc is put into the link register to make a return possible
  # a return is affected by moving the stored link register into the pc, effectively a branch

  # swi (SoftWareInterrupt) or system call is how we call the kernel.
  # in Arm the register layout is different and so we have to place the syscall code into register 7
  # Registers 0-6 hold the call values as for a normal c call
  class CallInstruction < Register::Branch
    include Constants
    include Attributed

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
        arg = @first
        if arg.is_a?(Register::Label) or arg.is_a?(Parfait::TypedMethod)
          #relative addressing for jumps/calls
          # but because of the arm "theoretical" 3- stage pipeline,
          # we have to subtract 2 words (fetch/decode)
          if(arg.is_a? Register::Label)
            diff =  arg.position - self.position - 8
          else
            # But, for methods, this happens to be the size of the object header,
            # so there it balances out, but not blocks
            # have to use the code, not the mthod object for methods
            diff = arg.binary.position - self.position
          end
          arg = diff
        end
        if (arg.is_a?(Numeric))
          jmp_val = arg >> 2
          packed = [jmp_val].pack('l')
          # signed 32-bit, condense to 24-bit
          # TODO add check that the value fits into 24 bits
          io << packed[0,3]
        else
          raise "else not Attributed arg =\n#{arg.to_s[0..1000]}: #{inspect[0..1000]}"
        end
        io.write_uint8 op_bit_code | (COND_CODES[@attributes[:condition_code]] << 4)
      when :swi
        arg = @first
        if (arg.is_a?(Numeric))
          packed = [arg].pack('L')[0,3]
          io << packed
          io.write_uint8 0b1111 | (COND_CODES[@attributes[:condition_code]] << 4)
        else
          raise "invalid operand argument expected literal not #{arg} #{inspect}"
        end
      else
        raise "Should not be the case #{inspect}"
      end
    end

    def uses
      if opcode == :call
        @first.args.collect {|arg| arg.register }
      else
        []
      end
    end
    def assigns
      if opcode == :call
        [RegisterValue.new(RegisterMachine.instance.return_register)]
      else
        []
      end
    end
    def to_s
      "#{opcode} #{@first} #{super}"
    end
  end
end

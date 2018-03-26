module Arm
  # ADDRESSING MODE 4

  class StackInstruction < Instruction

    def initialize(first , attributes)
      super(nil)
      @attributes = attributes
      @first = first
      @attributes[:update_status] = 0 if @attributes[:update_status] == nil
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      @attributes[:opcode] = attributes[:opcode]
      @rn = :sp # sp register
    end

    # don't overwrite instance variables, to make assembly repeatable
    def assemble(io)
      operand = 0
      raise "invalid operand argument #{inspect}" unless (@first.is_a?(Array))
      @first.each do |r|
        raise "nil register in push, index #{r}- #{inspect}" if r.nil?
        operand = operand | (1 << reg_code(r))
      end
      val = operand
      val = val | (reg_code(@rn) <<             16)
      val = val | (is_pop <<              16 + 4) #20
      val = val | (1          <<          16 + 4 + 1)
      val = val | (@attributes[:update_status] <<  16 + 4 + 1 + 1)
      val = val | (up_down <<             16 + 4 + 1 + 1 + 1)
      val = val | (pre_post_index <<      16 + 4 + 1 + 1 + 1 + 1)#24
      val = val | instruction_code
      val = val | (cond <<                16 + 4 + 1 + 1 + 1 + 1 + 2 + 2)
      io.write_unsigned_int_32 val
    end

    def cond
      if @attributes[:condition_code].is_a?(Symbol)
        COND_CODES[@attributes[:condition_code]]
      else
        @attributes[:condition_code]
      end
    end
    def instuction_class
      0b10 # OPC_STACK
    end
    def up_down
      (opcode == :push) ?  0 :  1
    end
    alias :is_pop :up_down

    def pre_post_index
      (opcode == :push) ?  1 :  0
    end

    def regs
      @first
    end

    def to_s
      "#{opcode} [#{@first.join(',') }] #{super}"
    end
  end

end

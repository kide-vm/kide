module Arm
  class MoveInstruction < Instruction
    include Arm::Constants

    def initialize to , from , options = {}
      super(options)
      @to = to
      @from = from #from.is_a?(Fixnum) ? Virtual::IntegerConstant.new(from) : from
      raise "move must have from set #{inspect}" unless from
      @attributes[:update_status] = 0 if @attributes[:update_status] == nil
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      @attributes[:opcode] = attributes[:opcode]
      @operand = 0

      @immediate = 0
      @rn = :r0 # register zero = zero bit pattern
      @from = Virtual::IntegerConstant.new( @from ) if( @from.is_a? Fixnum )
      @extra = nil
    end
    attr_accessor :to , :from

    # arm intructions are pretty sensible, and always 4 bytes (thumb not supported)
    # but not all constants fit into the part of the instruction that is left after the instruction code,
    # so large moves have to be split into two instructions.
    # we handle this "transparently", just this instruction looks longer
    # alas, full transparency is not achieved as we only know when to use 2 instruction once we know where the
    # other object is, and that position is only set after code positions have been determined (in link) and so
    # see below in assemble
    def mem_length
      @extra ? 8 : 4
    end

    def assemble(io)
      # don't overwrite instance variables, to make assembly repeatable
      rn = @rn
      operand = @operand
      immediate = @immediate
      right = @from
      if right.is_a?(Parfait::Object)
        r_pos = right.position
        # do pc relative addressing with the difference to the instuction
        # 8 is for the funny pipeline adjustment (ie pc pointing to fetch and not execute)
        right = Virtual::IntegerConstant.new( r_pos - self.position - 8 )
        puts "Position #{r_pos} from #{self.position} = #{right}"
        rn = :pc
      end
      if (right.is_a?(Numeric))
        if (right.fits_u8?)
          # no shifting needed
          operand = right.integer
          immediate = 1
        elsif (op_with_rot = calculate_u8_with_rr(right))
          operand = op_with_rot
          immediate = 1
        else
            # unfortunately i was wrong in thinking the pi is armv7. The good news is the code below implements
            # the movw instruction (armv7 for moving a word) and works
            #armv7 raise "Too big #{right.integer} " if (right.integer >> 16) > 0
            #armv7 operand = (right.integer & 0xFFF)
            #armv7 immediate = 1
            #armv7 rn = (right.integer >> 12)
            # a little STRANGE, that the armv7 movw (move a 2 byte word) is an old test opcode, but there it is
            #armv7 @attributes[:opcode] = :tst
          raise "No negatives implemented #{right} " if right.integer < 0
          # and so it continues: when we notice that the const doesn't fit, first time we raise an
          # error,but set the extra flag, to say the instruction is now 8 bytes
          # then on subsequent assemblies we can assemble
          unless @extra
            @extra = 1
            raise ::Register::LinkException.new("cannot fit numeric literal argument in operand #{right.inspect}")
          end
          # now we can do the actual breaking of instruction, by splitting the operand
          first = Virtual::IntegerConstant.new(right.integer & 0xFFFFFF00)
          operand = calculate_u8_with_rr( first )
          raise "no fit for #{right}" unless operand
          immediate = 1
          @extra = ArmMachine.add( to , to , (right.integer & 0xFF) )
          #TODO: this is still a hack, as it does not encode all possible values. The way it _should_ be done
          # is to check that the first part is doabe with u8_with_rr AND leaves a u8 remainder
        end
      elsif (right.is_a?(Symbol) or right.is_a?(::Register::RegisterReference))
        operand = reg_code(right)
        immediate = 0                # ie not immediate is register
      else
        raise "invalid operand argument #{right.class} , #{self.class}"
      end
      op =  shift_handling
      instuction_class = 0b00 # OPC_DATA_PROCESSING
      val = shift(operand , 0)
      val |= shift(op , 0) # any barrel action, is already shifted
      val |= shift(reg_code(@to) ,            12)
      val |= shift(reg_code(rn) ,            12+4)
      val |= shift(@attributes[:update_status] , 12+4+4)#20
      val |= shift(op_bit_code ,        12+4+4  +1)
      val |= shift(immediate ,                  12+4+4  +1+4)
      val |= shift(instuction_class ,   12+4+4  +1+4+1)
      val |= shift(cond_bit_code ,      12+4+4  +1+4+1+2)
      io.write_uint32 val
      # by now we have the extra add so assemble that
      if(@extra)
        @extra.assemble(io)
        #puts "Assemble extra at #{val.to_s(16)}"
      end
    end
    def shift val , by
      raise "Not integer #{val}:#{val.class} in #{inspect}" unless val.is_a? Fixnum
      val << by
    end

    def uses
      @from.is_a?(Constant) ? [] : [@from.register]
    end
    def assigns
      [@to.register]
    end
  end
end

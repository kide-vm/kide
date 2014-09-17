module Arm

  class MoveInstruction < Register::MoveInstruction
    include Arm::Constants

    def initialize(to , from , attributes) 
      super(to , from , attributes)
      @attributes[:update_status] = 0 if @attributes[:update_status] == nil
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      @attributes[:opcode] = attributes[:opcode]
      @operand = 0

      @immediate = 0      
      @rn = :r0 # register zero = zero bit pattern
      @from = Virtual::IntegerConstant.new( @from ) if( @from.is_a? Fixnum )
      @extra = nil
    end
    
    # arm intrucions are pretty sensible, and always 4 bytes (thumb not supported)
    # but not all constants fit into the part of the instruction that is left after the instruction code,
    # so large moves have to be split into two instructions. 
    # we handle this "transparently", just this instruction looks longer
    # alas, full transparency is not achieved as we only know when to use 2 instruction once we know where def the
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
      complex = false
      right = @from
      if right.is_a?(Virtual::ObjectConstant)
        r_pos = right.position
        # do pc relative addressing with the difference to the instuction
        # 8 is for the funny pipeline adjustment (ie pc pointing to fetch and not execute)
        right = Virtual::IntegerConstant.new( r_pos - self.position - 8 )
        puts "Position #{r_pos} from #{self.position} = #{right}"
        right = Virtual::IntegerConstant.new(r_pos) if right.integer > 255
        rn = :pc
      end
      if (right.is_a?(Virtual::IntegerConstant))
        if (right.fits_u8?)
          # no shifting needed
          operand = right.integer
          immediate = 1
        elsif (op_with_rot = calculate_u8_with_rr(right))
          operand = op_with_rot
          immediate = 1
          raise "hmm"
        else
          # and so it continues: when we notice that the const doesn't fit, first time we raise an 
          # error,but set the extra flag, to say the instruction is now 8 bytes
          # then on subsequent assemlies we can assemble
          unless @extra
            @extra = 1
            raise ::Register::LinkException.new("cannot fit numeric literal argument in operand #{right.inspect}") 
          end
          # now we can do the actual breaking of instruction
          raise "at leat we got here"
        end
      elsif (right.is_a?(Symbol) or right.is_a?(Virtual::Integer))
        operand = reg_code(right)    #integer means the register the integer is in (otherwise constant)
        immediate = 0                # ie not immediate is register
      else
        raise "invalid operand argument #{right.inspect} , #{inspect}"
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
    end
    def shift val , by
      raise "Not integer #{val}:#{val.class} in #{inspect}" unless val.is_a? Fixnum
      val << by
    end
  end
end

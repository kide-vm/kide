module Risc

  # RiscValue is like a variable name, a storage location. The location is a register off course.

  class RiscValue

    attr_reader :symbol , :type , :value

    attr_accessor :builder

    def initialize( reg , type , value = nil)
      raise "not reg #{reg}" unless self.class.look_like_reg( reg )
      @type = type
      @symbol = reg
      @value = value
    end

    def to_s
      s = "#{symbol}:#{type}"
      s += ":#{value}" if value
      s
    end

    def reg_no
      @symbol.to_s[1 .. -1].to_i
    end

    def self.look_like_reg is_it
      return true if is_it.is_a? RiscValue
      return false unless is_it.is_a? Symbol
      if( [:lr , :pc].include? is_it )
        return true
      end
      if( (is_it.to_s.length <= 3) and (is_it.to_s[0] == "r"))
        # could tighten this by checking that the rest is a number
        return true
      end
      return false
    end

    def == other
      return false if other.nil?
      return false if other.class != RiscValue
      symbol == other.symbol
    end

    #helper method to calculate with register symbols
    def next_reg_use( type , value = nil )
      int = @symbol[1,3].to_i
      raise "No more registers #{self}" if int > 8
      sym = "r#{int + 1}".to_sym
      RiscValue.new( sym , type, value)
    end

    def sof_reference_name
      @symbol
    end

    # can't overload "=" , so use shift for it.
    # move the right side to the left. Left (this) is a RiscValue
    # right value may be
    # - constant (Parfait object) , resulting in a LoadConstant
    # - another RiscValue, resulting in a Transfer instruction
    # - an RValue, which gets procuced by the [] below
    def <<( load )
      case load
      when Parfait::Object
        ins = Risc.load_constant("#{load.class} to #{self.type}" , load , self)
      when RiscValue
        ins = Risc.transfer("#{load.type} to #{self.type}" , load , self)
      when RValue
        load >> self
      else
        raise "not implemented"
      end
      builder.add_instruction(ins) if builder
      return ins
    end

    # create a RegToSlot instruction
    # right hand must be an RValue
    def >>( slot )
      raise "not RValue #{slot}" unless slot.is_a?(RValue)
      reg_to_slot = Risc.reg_to_slot("#{self.type} -> #{slot.register.type}[#{slot.index}]" , self, slot.register, slot.index)
      builder.add_instruction(reg_to_slot) if builder
      reg_to_slot
    end
    # just capture the values in an intermediary object (RValue)
    # The RValue then gets used in a RegToSlot ot SlotToReg, where
    # the values are unpacked to call Risc.reg_to_slot or Risc.slot_to_reg
    def []( index )
      RValue.new( self , index , builder)
    end
  end

  # Just a struct, see comment for [] of RiscValue
  #
  class RValue
    attr_reader :register , :index , :builder
    def initialize(register, index , builder)
      @register , @index , @builder = register , index , builder
    end

    # fullfil the objects purpose by creating a SlotToReg instruction from
    # itself (the slot) and the register given
    def >>( reg )
      raise "not reg #{reg}" unless reg.is_a?(RiscValue)
      slot = Risc.slot_to_reg("#{register.type}[#{index}] -> #{reg.type}" , @register , @index , reg)
      builder.add_instruction(slot) if builder
      slot
    end
  end

  # The register we use to store the current message object is :r0
  def self.message_reg
    RiscValue.new :r0 , :Message
  end

  # The register we use to store the new message object is :r3
  # The new message is the one being built, to be sent
  def self.new_message_reg
    RiscValue.new :r1 , :Message
  end

  # The first scratch register. There is a next_reg_use to get a next and next.
  # Current thinking is that scratch is schatch between instructions
  def self.tmp_reg( type , value = nil)
    RiscValue.new :r1 , type , value
  end

end

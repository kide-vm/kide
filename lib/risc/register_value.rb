module Risc

  # RegisterValue is like a variable name, a storage location.
  # The location is a register off course.
  # The type is always known, and sometimes the value too
  # Or something about the value, like some instances types
  #
  # When participating in the builder dsl, a builder may be set to get the
  # results of dsl operations (like <<) back to the builder
  class RegisterValue

    attr_reader :symbol , :type , :value

    attr_accessor :builder

    # The first arg is a symbol :r0 - :r12
    # Second arg is the type, which may be given as the symbol of the class name
    # (internally we store the actual type instance, resolving any symbols)
    # A third value may give extra information. This is a hash, where keys may
    # be :value, or :value_XX or :type_XX to indicate value or type information
    # for an XX instance
    def initialize( reg , type , extra = {})
      raise "Not Hash #{extra}"  unless extra.is_a?(Hash)
      raise "not reg #{reg}" unless self.class.look_like_reg( reg )
      type = Parfait.object_space.get_type_by_class_name(type) if type.is_a?(Symbol)
      @type = type
      @symbol = reg
      @value = extra
    end

    # using the registers type, resolve the slot to an index
    # Using the index and the register, add a SlotToReg to the instruction
    def resolve_and_add(slot , instruction , compiler)
      index = resolve_index( slot )
      new_left = get_new_left( slot , compiler )
      instruction << Risc::SlotToReg.new( "SlotLoad #{type}[#{slot}]" , self ,index, new_left)
      new_left
    end

    # resolve the given slot name (instance variable name) to an index using the type
    # RegisterValue has the current type, so we just look up the index in the type
    def resolve_index(slot)
      #puts "TYPE #{type} obj:#{object} var:#{slot} comp:#{compiler}"
      index = type.variable_index(slot)
      raise "Index not found for #{slot} in #{type} of type #{@type}" unless index
      return index
    end

    # when following variables in resolve_and_add, get a new RegisterValue
    # that represents the new value.
    # Ie in "normal case" a the same register, with the type of the slot
    #  (the not normal case, the first reduction, uses a new register, as we don't
    #   overwrite the message)
    # We get the type with resolve_new_type
    def get_new_left(slot, compiler)
      new_type = resolve_new_type(slot , compiler)
      if( @symbol == :r0 )
        new_left = compiler.use_reg( new_type )
      else
        new_left = RegisterValue.new( @symbol , new_type)
      end
      new_left
    end

    # resolve the type of the slot, by inferring from it's name, using the type
    # scope related slots are resolved by the compiler
    def resolve_new_type(slot, compiler)
      case slot
      when :frame , :arguments , :receiver
        type = compiler.resolve_type(slot)
      when Symbol
        type = @type.type_for(slot)
        raise "Not found object #{slot}: in #{@type}" unless type
      else
        raise "Not implemented object #{slot}:#{slot.class}"
      end
      #puts "RESOLVE in #{@type.class_name} #{slot}->#{type}"
      return type
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
      return true if is_it.is_a? RegisterValue
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
      return false if other.class != RegisterValue
      symbol == other.symbol
    end

    #helper method to calculate with register symbols
    def next_reg_use( type , value = nil )
      int = @symbol[1,3].to_i
      raise "No more registers #{self}" if int > 11
      sym = "r#{int + 1}".to_sym
      RegisterValue.new( sym , type, value)
    end

    def rxf_reference_name
      @symbol
    end

    # can't overload "=" , so use shift for it.
    # move the right side to the left. Left (this) is a RegisterValue
    # right value may be
    # - constant (Parfait object) , resulting in a LoadConstant
    # - another RegisterValue, resulting in a Transfer instruction
    # - an RValue, resulting in an SlotToReg
    def <<( right )
      case right
      when Parfait::Object , Symbol
        ins = Risc.load_constant("#{right.class} to #{self.type}" , right , self)
      when RegisterValue
        ins = Risc.transfer("#{right.type} to #{self.type}" , right , self)
      when RValue
        ins = Risc.slot_to_reg("#{right.register.type}[#{right.index}] -> #{self.type}" , right.register , right.index , self)
      else
        raise "not implemented for #{right.class}:#{right}"
      end
      builder.add_code(ins) if builder
      return ins
    end

    def -( right )
      raise "operators only on registers, not #{right.class}" unless right.is_a? RegisterValue
      op = Risc.op("#{self.type} - #{right.type}", :- , self , right )
      builder.add_code(op) if builder
      op
    end

    # just capture the values in an intermediary object (RValue)
    # The RValue then gets used in a RegToSlot ot SlotToReg, where
    # the values are unpacked to call Risc.reg_to_slot or Risc.slot_to_reg
    def []( index )
      RValue.new( self , index , builder)
    end
  end

  # Just a struct, see comment for [] of RegisterValue
  #
  class RValue
    attr_reader :register , :index , :builder
    def initialize(register, index , builder)
      @register , @index , @builder = register , index , builder
    end

    # fullfil the objects purpose by creating a RegToSlot instruction from
    # itself (the slot) and the register given
    def <<( reg )
      raise "not reg #{reg}" unless reg.is_a?(RegisterValue)
      reg_to_slot = Risc.reg_to_slot("#{reg.type.class_name} -> #{register.type.class_name}[#{index}]" , reg , register, index)
      builder.add_code(reg_to_slot) if builder
      reg_to_slot
    end

  end

  # The register we use to store the current message object is :r0
  def self.message_reg
    RegisterValue.new :r0 , :Message
  end

  # The register we use to store the new message object is :r3
  # The new message is the one being built, to be sent
  def self.new_message_reg
    RegisterValue.new :r1 , :Message
  end

  # The first scratch register. There is a next_reg_use to get a next and next.
  # Current thinking is that scratch is schatch between instructions
  def self.tmp_reg( type , extra = {})
    RegisterValue.new :r1 , type , extra
  end

end

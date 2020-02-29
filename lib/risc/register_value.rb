module Risc

  # RegisterValue is like a variable name, a storage location.
  # The location is a register off course.
  # The type is always known, and sometimes the value too
  # Or something about the value, like some instances types
  #
  # When participating in the builder dsl, a builder may be set to get the
  # results of dsl operations (like <<) back to the builder
  class RegisterValue

    attr_reader :symbol , :type , :extra

    attr_reader :builder

    # The first arg is a symbol :r0 - :r12
    # Second arg is the type, which may be given as the symbol of the class name
    # (internally we store the actual type instance, resolving any symbols)
    # A third value may give extra information. This is a hash, where keys may
    # be :value, or :value_XX or :type_XX to indicate value or type information
    # for an XX instance
    def initialize( reg , type , extra = {})
      extra = {} unless extra
      raise "Not Hash #{extra}"  unless extra.is_a?(Hash)
      type = Parfait.object_space.get_type_by_class_name(type) if type.is_a?(Symbol)
      raise "No type #{reg}" unless type
      @type = type
      @symbol = reg
      @extra = extra
    end

    def class_name
      return :fixnum unless @type
      @type.class_name
    end

    # allows to set the builder, which is mainly done by the builder
    # but sometimes, eg in exit, one nneds to create the reg by hand and set
    # return the RegisterValue for chaining in assignment
    def set_builder( builder )
      @builder = builder
      self
    end

    # using the registers type, resolve the slot to an index
    # Using the index and the register, add a SlotToReg to the instruction
    def resolve_and_add(slot , compiler)
      index = resolve_index(slot)
      new_left = get_new_left( slot , compiler )
      compiler.add_code Risc::SlotToReg.new( "SlotLoad #{type}[#{slot}]" , self ,index, new_left)
      new_left
    end

    # resolve the given slot name (instance variable name) to an index using the type
    # RegisterValue has the current type, so we just look up the index in the type
    def resolve_index(slot)
      #puts "TYPE #{type} var:#{slot} "
      index = type.variable_index(slot)
      raise "Index not found for #{slot} in #{type} of type #{@type}" unless index
      return index
    end

    def type_at(index)
      type.type_at(index)
    end

    # reduce integer to fixnum and add instruction if builder is used
    def reduce_int
      reduce = Risc::SlotToReg.new( "int -> fix" , self , Parfait::Integer.integer_index , self)
      builder.add_code(reduce) if builder
      reduce
    end

    # when following variables in resolve_and_add, get a new RegisterValue
    # that represents the new value.
    # Ie in "normal case" a the same register, with the type of the slot
    #  (the not normal case, the first reduction, uses a new register, as we don't
    #   overwrite the message)
    # We get the type with resolve_new_type
    def get_new_left(slot, compiler)
      new_type = extra["type_#{slot}".to_sym]
      new_type , extra = compiler.slot_type(slot , type) unless new_type
      new_name = "#{@symbol}.#{slot}"
      raise "no #{self}" if RegisterValue.look_like_reg(@symbol)
      puts "New name #{new_name}"
      new_left = RegisterValue.new( new_name.to_sym , new_type , extra)
      new_left
    end

    def to_s
      s = "#{symbol}:#{class_name}"
      s += ":#{extra}" unless extra.empty?
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
    def next_reg_use( type , extra = {} )
      int = @symbol[1,3].to_i
      raise "No more registers #{self}" if int > 11
      sym = "r#{int + 1}".to_sym
      RegisterValue.new( sym , type, extra)
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
      when Symbol
        ins = Risc::LoadConstant.new("#{right.class} to #{self.type}" , right , self)
      when Parfait::Object
        ins = Risc::LoadConstant.new("#{right.class} to #{self.type}" , right , self)
        builder.compiler.add_constant(right) if builder
      when Label
        ins = Risc::LoadConstant.new("#{right.class} to #{self.type}" , right , self)
        builder.compiler.add_constant(right.address) if builder
      when ::Integer
        ins = Risc.load_data("#{right.class} to #{self.type}" , right , self)
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

    # similar to above (<< which produces slot_to_reg), this produces byte_to_reg
    # since << covers all other cases, this must have a RValue as the right
    def <=( right )
      raise "not implemented for #{right.class}:#{right}" unless right.is_a?( RValue )
      ins = Risc.byte_to_reg("#{right.register.type}[#{right.index}] -> #{self.type}" , right.register , right.index , self)
      builder.add_code(ins) if builder
      return ins
    end

    def -( right )
      raise "operators only on registers, not #{right.class}" unless right.is_a? RegisterValue
      op = Risc.op("#{self.type} - #{right.type}", :- , self , right )
      builder.add_code(op) if builder
      op
    end

    # create operator instruction for self and add
    # doesn't read quite as smoothly as one would like, but better than the compiler version
    def op( operator , right)
      ret = Risc.op( "operator #{operator}" , operator , self , right)
      builder.add_code(ret) if builder
      ret
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
      reg_to_slot = Risc.reg_to_slot("#{reg.class_name} -> #{register.class_name}[#{index}]" , reg , register, index)
      builder.add_code(reg_to_slot) if builder
      reg_to_slot
    end

    # similar to above (<< which produces reg_to_slot), this produces reg_to_byte
    # from itself (the slot) and the register given
    def <=( reg )
      raise "not reg #{reg}" unless reg.is_a?(RegisterValue)
      reg_to_byte = Risc.reg_to_byte("#{reg.class_name} -> #{register.class_name}[#{index}]" , reg , register, index)
      builder.add_code(reg_to_byte) if builder
      reg_to_byte
    end

  end

  # The register we use to store the current message object is :r0
  def self.message_reg
    RegisterValue.new :r0 , :Message
  end
  # a named version of the message register, called :message
  def self.message_named_reg
    RegisterValue.new :message , :Message
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

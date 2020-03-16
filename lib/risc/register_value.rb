module Risc

  # RegisterValue is like a variable name, a storage location.
  # The location is a register off course.
  # The type is always known, and sometimes the value too
  # Or something about the value, like some instances types
  #
  # When participating in the compiler dsl, a compiler may be set to get the
  # results of dsl operations (like <<) back to the compiler
  class RegisterValue

    attr_reader :symbol , :type , :extra

    attr_reader :compiler

    # The first arg is a symbol :r0 - :r12
    # Second arg is the type, which may be given as the symbol of the class name
    # (internally we store the actual type instance, resolving any symbols)
    # A third value may give extra information. This is a hash, where keys may
    # be :value, or :value_XX or :type_XX to indicate value or type information
    # for an XX instance
    def initialize( reg , type , extra = {})
      extra = {} unless extra
      @extra = extra
      @symbol = reg
      raise "not Symbol #{symbol}:#{symbol.class}" unless symbol.is_a?(Symbol)
      raise "Not Hash #{extra}"  unless extra.is_a?(Hash)
      known_type(type)
    end

    def class_name
      return :fixnum unless @type
      @type.class_name
    end

    # allows to set the compiler, which is mainly done by the compiler
    # but sometimes, eg in exit, one nneds to create the reg by hand and set
    # return the RegisterValue for chaining in assignment
    def set_compiler( compiler )
      @compiler = compiler
      self
    end

    # basically set the type with the given symbol. Symbol is resolved to type
    # just like in constructor
    # return self for chaining
    def known_type( type )
      type = Parfait.object_space.get_type_by_class_name(type) if type.is_a?(Symbol)
      raise "No type #{type} for #{self}" unless type
      @type = type
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

    # reduce integer to fixnum and add instruction if compiler is used
    # TODO: check type of self, should be integer, and ensure it is
    # TODO: find a type for the result, maybe fixnum , or data ?
    # TODO also check types on reg_to_slot
    def reduce_int(check = true)
      raise "type not int #{type.name}" if check && type.name != "Integer_Type"
      new_name = "#{@symbol}.data_1"
      new_reg = RegisterValue.new( new_name.to_sym , :Integer , extra).set_compiler(compiler)
      reduce = Risc::SlotToReg.new( "int -> fix" , self , Parfait::Integer.integer_index , new_reg)
      compiler.add_code(reduce) if compiler
      reduce.register
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
    # - an RegisterSlot, resulting in an SlotToReg
    def <<( right )
      case right
      when Label
        ins = Risc::LoadConstant.new("#{right.class} to #{self.type}" , right , self)
        compiler.compiler.add_constant(right.address) if compiler
      when ::Integer
        ins = Risc.load_data("#{right.class} to #{self.type}" , right , self)
      when RegisterValue
        ins = Risc.transfer("#{right.type} to #{self.type}" , right , self)
      when RegisterSlot
        index = right.register.resolve_index(right.index)
        ins = SlotToReg.new("#{right.register.type}[#{right.index}] -> #{self.type}" , right.register , index , self)
      else
        raise "not implemented for #{right.class}:#{right}"
      end
      compiler.add_code(ins) if compiler
      return ins
    end

    # similar to above (<< which produces slot_to_reg), this produces byte_to_reg
    # since << covers all other cases, this must have a RegisterSlot as the right
    def <=( right )
      raise "not implemented for #{right.class}:#{right}" unless right.is_a?( RegisterSlot )
      raise "Right index must be register #{right.index}" unless(right.index.is_a?(RegisterValue))
      ins = Risc.byte_to_reg("#{right.register.type}[#{right.index}] -> #{self.type}" , right.register , right.index , self)
      compiler.add_code(ins) if compiler
      return ins
    end

    def -( right )
      raise "operators only on registers, not #{right.class}" unless right.is_a? RegisterValue
      op = Risc.op("#{self.type} - #{right.type}", :- , self , right )
      compiler.add_code(op) if compiler
      op
    end

    # create operator instruction for self and add
    # doesn't read quite as smoothly as one would like, but better than the compiler version
    # result, the third paraameter, may be nil, in which case a register will be generated
    # (off coourse using the third parameter makes it look even worse TBC)
    def op( operator , right , result = nil)
      right = right.to_reg() if(right.is_a?(RegisterSlot))
      ret = Risc.op( "operator #{operator}" , operator , self , right , result)
      compiler.add_code(ret) if compiler
      ret.result
    end

    # just capture the values in an intermediary object (RegisterSlot)
    # The RegisterSlot then gets used in a RegToSlot or SlotToReg, where
    # the values are unpacked to call Risc.reg_to_slot or Risc.slot_to_reg
    def []( index )
      RegisterSlot.new( self , index , compiler)
    end
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

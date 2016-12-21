module Register

  # RegisterValue is like a variable name, a storage location. The location is a register off course.

  class RegisterValue

    attr_accessor :symbol , :type , :value

    def initialize r , type , value = nil
      raise "wrong type for register init #{r}" unless r.is_a? Symbol
      raise "double r #{r}" if r.to_s[0,1] == "rr"
      raise "not reg #{r}" unless self.class.look_like_reg r
      type = :Integer if type == :int
      raise "Legacy type error, should be class name not ref" if (type == :ref)
      @type = type
      @symbol = r
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
    def next_reg_use type , value = nil
      int = @symbol[1,3].to_i
      raise "No more registers #{self}" if int > 12
      sym = "r#{int + 1}".to_sym
      RegisterValue.new( sym , type, value)
    end

    def sof_reference_name
      @symbol
    end

    def self.convert(unused)
      unused
    end
  end

  # Here we define the mapping from virtual machine objects, to register machine registers
  #

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
  def self.tmp_reg type , value = nil
    RegisterValue.new :r2 , type , value
  end

  # The first arg is a class name (possibly lowercase) and the second an instance variable name.
  # By looking up the class and the type for that class, we can resolve the instance
  # variable name to an index.
  # The class can be mapped to a register, and so we get a memory address (reg+index)
  def self.resolve_index( clazz_name , instance_name )
    return instance_name unless instance_name.is_a? Symbol
    real_name = clazz_name.to_s.split('_').last.capitalize.to_sym
    clazz = Parfait::Space.object_space.get_class_by_name(real_name)
    raise "Class name not given #{real_name}" unless clazz
    index = clazz.instance_type.variable_index( instance_name )
    raise "Instance name=#{instance_name} not found on #{real_name}" unless index.is_a?(Numeric)
    return index #  the type word is at index 0, but type is a list and starts at 1 == type
  end

  # if a symbol is given, it may be one of the four objects that the vm knows.
  # These are mapped to register references.
  # The valid symbols (:message, :self,:locals,:new_message) are the same that are returned
  # by the slots. All data (at any time) is in one of the instance variables of these four
  # objects. Register defines module methods with the same names (and _reg)
  def self.resolve_to_register reference
    register = reference
    if reference.is_a? Symbol
      case reference
      when :message
        register = message_reg
      when :new_message
        register = new_message_reg
      else
        raise "not recognized register reference #{reference}"
      end
    end
    return register
  end

end

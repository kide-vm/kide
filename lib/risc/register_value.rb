module Risc

  # RiscValue is like a variable name, a storage location. The location is a register off course.

  class RiscValue

    attr_accessor :symbol , :type , :value

    def initialize r , type , value = nil
      raise "wrong type for register init #{r}" unless r.is_a? Symbol
      raise "double r #{r}" if r.to_s[0,1] == "rr"
      raise "not reg #{r}" unless self.class.look_like_reg r
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

  end

  # Here we define the mapping from virtual machine objects, to register machine registers
  #

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

  # The first arg is a class name (possibly lowercase) and the second an instance variable name.
  # By looking up the class and the type for that class, we can resolve the instance
  # variable name to an index.
  # The class can be mapped to a register, and so we get a memory address (reg+index)
  # Third arg, compiler, is only needed to resolve receiver/arguments/frame
  def self.resolve_to_index(object , variable_name ,compiler = nil)
    return variable_name if variable_name.is_a?(Integer) or variable_name.is_a?(RiscValue)
    object = object.type if object.is_a?(RiscValue)
    case object
    when :frame
      type = compiler.method.frame_type
    when :message , :next_message , :caller
      type = Parfait.object_space.get_class_by_name(:Message).instance_type
    when :arguments
      type = compiler.method.arguments_type
    when :receiver
      type = compiler.method.for_type
    when Parfait::Object
      type = Parfait.object_space.get_class_by_name( object.class.name.split("::").last.to_sym).instance_type
    when Symbol
      clazz = Parfait.object_space.get_class_by_name(object)
      raise "Not implemented/found object #{object}:#{object.class}" unless clazz
      type = clazz.instance_type
    else
      raise "Not implemented/found object #{object}:#{object.class}"
    end
    index = type.variable_index(variable_name)
    raise "Index not found for #{variable_name} in #{object} of type #{type}" unless index
    return index
  end

  # if a symbol is given, it may be the message or the new_message.
  # These are mapped to register references.
  # The valid symbols (:message,:new_message) are the same that are returned
  # by the slots. All data (at any time) is in one of the instance variables of these two
  # objects. Risc defines module methods with the same names (and _reg)
  def self.resolve_to_register( reference )
    return reference if reference.is_a?(RiscValue)
    case reference
    when :message
      return message_reg
    when :new_message
      return new_message_reg
    else
      raise "not recognized register reference #{reference} #{reference.class}"
    end
  end

end

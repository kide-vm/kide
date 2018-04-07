module Risc

  class Builder

    attr_reader :built , :compiler

    # pass a compiler, to which instruction are added (usually)
    # call build or build_and_return with a block
    def initialize(compiler)
      @compiler = compiler
      @names = {}
    end

    # make the magic: convert incoming names into registers that have the
    # type set according to the name (using resolve_type)
    # anmes are stored, so subsequent calls use the same register
    def method_missing(*args)
      super if args.length != 1
      name = args[0]
      return @names[name] if @names.has_key?(name)
      if name == :message
        reg = Risc.message_reg
        reg.builder = self
      elsif name.to_s.index("label")
        reg = Risc.label( name.to_s , "#{name}_#{object_id}")
      else
        type = Risc.resolve_type(name , @compiler) #checking
        reg = @compiler.use_reg( type.object_class.name )
        reg.builder = self
      end
      @names[name] = reg
      reg
    end

    def if_zero( label )
      add Risc::IsZero.new("jump if zero" , label)
    end
    def if_not_zero( label )
      add Risc::IsNotZero.new("jump if not zero" , label)
    end
    def branch( label )
      add Risc::Branch.new("jump to" , label)
    end

    # build code using dsl (see __init__ or MessageSetup for examples)
    # names (that ruby would resolve to a variable/method) are converted
    # to registers. << means assignment and [] is supported both on
    # L and R values (but only one at a time). R values may also be constants.
    # Basically this allows to create LoadConstant, RegToSlot, SlotToReg and
    # Transfer instructions with extremely readable code.
    # example:
    #  space << Parfait.object_space # load constant
    #  message[:receiver] << space  #make current message (r0) receiver the space
    #
    # build result is available as built, but also gets added to compiler
    def build(&block)
      risc = build_and_return(&block)
      @compiler.add_code(risc)
      risc
    end

    # version of build that does not add to compiler, just returns the code
    def build_and_return(&block)
      @built = nil
      instance_eval(&block)
      risc = @built
      @built = nil
      return risc
    end

    def add(ins)
      if(@built)
        @built << ins
      else
        @built = ins
      end
    end
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

  # The first arg is a class name (possibly lowercase) and the second an instance variable name.
  def self.resolve_type( object , compiler )
    object = object.type if object.is_a?(RiscValue)
    case object
    when :name
      type = Parfait.object_space.get_class_by_name( :Word ).instance_type
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
      object = object.to_s.camelize.to_sym
      clazz = Parfait.object_space.get_class_by_name(object)
      raise "Not implemented/found object #{object}:#{object.class}" unless clazz
      type = clazz.instance_type
    else
      raise "Not implemented/found object #{object}:#{object.class}"
    end
    return type
  end

  # The first arg is a class name (possibly lowercase) and the second an instance variable name.
  # By looking up the class and the type for that class, we can resolve the instance
  # variable name to an index.
  # The class can be mapped to a register, and so we get a memory address (reg+index)
  # Third arg, compiler, is only needed to resolve receiver/arguments/frame
  def self.resolve_to_index(object , variable_name ,compiler = nil)
    return variable_name if variable_name.is_a?(Integer) or variable_name.is_a?(RiscValue)
    type = resolve_type(object , compiler)
    index = type.variable_index(variable_name)
    raise "Index not found for #{variable_name} in #{object} of type #{type}" unless index
    return index
  end


end

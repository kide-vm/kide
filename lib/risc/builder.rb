module Risc

  class Builder

    attr_reader :built

    def initialize(compiler)
      @compiler = compiler
    end

    def method_missing(*args)
      super if args.length != 1
      name = args[0].to_s.capitalize.to_sym
      type = Risc.resolve_type(name , @compiler)
      reg = @compiler.use_reg( type )
      reg.builder = self
      puts reg
      reg
    end
    def build(&block)
      instance_eval(&block)
      return built
    end
    def add_instruction(ins)
      if(built)
        built << ins
      else
        @built = ins
      end
    end
  end

  class RValue
  end

  def self.build(compiler, &block)
    Builder.new(compiler).build( &block )
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

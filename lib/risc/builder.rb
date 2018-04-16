module Risc

  # A Builder is used to generate code, either by using it's api, or dsl
  #
  # The code that is generated can be added to the comiled method, ie to the compiler.
  # This is used to generate the builtin methods.
  # Or the code can be stored up and returned. This is used in Mom::to_risc methods
  class Builder

    attr_reader :built , :compiler

    # pass a compiler, to which instruction are added (usually)
    # second arg determines weather instructions are added (default true)
    # call build with a block to build
    def initialize(compiler, auto_add)
      @compiler = compiler
      @auto_add = auto_add
      @built = nil
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
      add_code Risc::IsZero.new("jump if zero" , label)
    end
    def if_not_zero( label )
      add_code Risc::IsNotZero.new("jump if not zero" , label)
    end
    def branch( label )
      add_code Risc::Branch.new("jump to" , label)
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
    # build result is available as built, but also gets added to compiler, if the
    # builder is created with default args
    def build(&block)
      instance_eval(&block)
      @built
    end

    # adding code to the builder either stores it in the built variable
    # or adds it straight to the compiler.
    # Depending on wether auto_add was given in construction.
    def add_code(ins)
      return @compiler.add_code(ins) if @auto_add
      if(@built)
        @built << ins
      else
        @built = ins
      end
    end

    # move a machine int from register "from" to a Parfait::Integer in register "to"
    # have to grab an integer from space and stick it in the "to" register first.
    def add_new_int( source , from, to )
      source += "add_new_int "
      space = compiler.use_reg(:Space)
      int = compiler.use_reg(:Integer)
      space_i = Risc.resolve_to_index(:Space, :next_integer)
      add_load_constant( source + "space" , Parfait.object_space , space  )
      add_slot_to_reg( source + "next_i1" , space , space_i , to)
      add_slot_to_reg( source + "next_i2" , to , Risc.resolve_to_index(:Integer, :next_integer) , int)
      add_reg_to_slot( source + "store link" , int , space , space_i  )
      add_reg_to_slot( source + "store value" , from , to , Parfait::Integer.integer_index)
    end

    # load receiver and the first argument (int)
    # return both registers
    def self_and_int_arg( source )
      me = add_known( :receiver )
      int_arg = load_int_arg_at(source , 1 )
      return me , int_arg
    end

    # Load the first argument, assumed to be integer
    def load_int_arg_at( source , at)
      int_arg = compiler.use_reg :Integer
      add_slot_to_reg(source , :message , :arguments , int_arg )
      add_slot_to_reg(source , int_arg , at + 1, int_arg ) #1 for type
      return int_arg
    end

    # assumed Integer in given register is replaced by the fixnum that it is holding
    def reduce_int( source , register )
      add_slot_to_reg( source + "int -> fix" , register , Parfait::Integer.integer_index , register)
    end

    # for computationally building code (ie writing assembler) these short cuts
    # help to instantiate risc instructions and add them immediately
    [:label, :reg_to_slot , :slot_to_reg , :load_constant, :load_data,
      :function_return , :function_call, :op ,
      :transfer , :reg_to_slot , :byte_to_reg , :reg_to_byte].each do |method|
      define_method("add_#{method}".to_sym) do |*args|
        add_code Risc.send( method , *args )
      end
    end

    def add_known(name)
      case name
      when :receiver
        ret = compiler.use_reg compiler.type
        add_slot_to_reg(" load self" , :message , :receiver , ret )
        return ret
      when :space
        space = Parfait.object_space
        reg = compiler.use_reg :Space , space
        add_load_constant( "load space", space , reg )
        return reg
      when :message
        reg = compiler.use_reg :Message
        add_transfer( "load message", Risc.message_reg , reg )
        return reg
      else
        raise "Unknow expression #{name}"
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
      object = object.to_s.camelise.to_sym
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

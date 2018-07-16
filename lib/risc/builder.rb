module Risc

  # A Builder is used to generate code, either by using it's api, or dsl
  #
  # There are two subclasses of Builder, depending of what one wants to do with the
  # generated code.
  #
  # CompilerBuilder: The code is added to the method_compiler.
  # This is used to generate the builtin methods.
  #
  # CodeBuilder: The code can be stored up and returned.
  #              This is used in Mom::to_risc methods
  #
  class Builder

    attr_reader :built , :compiler

    # pass a compiler, to which instruction are added (usually)
    # second arg determines weather instructions are added (default true)
    # call build with a block to build
    def initialize(compiler, for_source)
      @compiler = compiler
      @source = for_source
      @source_used = false
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
        reg = Risc.label( @source , "#{name}_#{object_id}")
        @source_used = true
      else
        type = infer_type(name )
        reg = @compiler.use_reg( type.object_class.name )
        reg.builder = self
      end
      @names[name] = reg
      reg
    end

    # infer the type from a symbol. In the simplest case the sybbol is the class name
    # But in building sometimes variations are needed, so next_message or caller work
    # too (and return Message)
    # An error is raised if the symbol/object can not be inferred
    def infer_type( name )
      name = :word if name == :name
      name = :message if name == :next_message
      name = :message if name == :caller
      sym = name.to_s.camelise.to_sym
      clazz = Parfait.object_space.get_class_by_name(sym)
      raise "Not implemented/found object #{name}:#{sym}" unless clazz
      return clazz.instance_type
    end

    def if_zero( label )
      @source_used = true
      add_code Risc::IsZero.new(@source , label)
    end
    def if_not_zero( label )
      @source_used = true
      add_code Risc::IsNotZero.new(@source , label)
    end
    def branch( label )
      @source_used = true
      add_code Risc::Branch.new(@source, label)
    end

    # build code using dsl (see __init__ or MessageSetup for examples)
    # names (that ruby would resolve to a variable/method) are converted
    # to registers. << means assignment and [] is supported both on
    # L and R values (but only one at a time). R values may also be constants.
    #
    # Basically this allows to create LoadConstant, RegToSlot, SlotToReg and
    # Transfer instructions with extremely readable code.
    # example:
    #  space << Parfait.object_space # load constant
    #  message[:receiver] << space  #make current message (r0) receiver the space
    #
    # build result is available as built, but also gets added to compiler, if the
    # builder is created with default args
    #
    def build(&block)
      instance_eval(&block)
      @built
    end

    def add_code(ins)
      raise "Must be implemented in subclass #{self}"
    end

    # move a machine int from register "from" to a Parfait::Integer in register "to"
    # have to grab an integer from space and stick it in the "to" register first.
    def add_new_int( source , from, to )
      source += "add_new_int "
      space = compiler.use_reg(:Space)
      int = compiler.use_reg(:Integer)
      space_i = space.resolve_index(:next_integer)
      add_load_constant( source + "space" , Parfait.object_space , space  )
      add_slot_to_reg( source + "next_i1" , space , space_i , to)
      add_slot_to_reg( source + "next_i2" , to , int.resolve_index(:next_integer) , int)
      add_reg_to_slot( source + "store link" , int , space , space_i  )
      add_reg_to_slot( source + "store value" , from , to , Parfait::Integer.integer_index)
    end

    # load receiver and the first argument (int)
    # return both registers
    def self_and_int_arg( source )
      me = add_known( :receiver )
      int_arg = load_int_arg_at(source , 0 )
      return me , int_arg
    end

    # Load the first argument, assumed to be integer
    def load_int_arg_at( source , at)
      int_arg = compiler.use_reg :Integer
      add_slot_to_reg(source , Risc.message_reg , :arguments , int_arg )
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
        if not @source_used
          args[0] = @source
          @source_used = true
        end
        add_code Risc.send( method , *args )
      end
    end

    def add_known(name)
      case name
      when :receiver
        message = Risc.message_reg
        ret_type = compiler.slot_type(:receiver, message.type)
        ret = compiler.use_reg( ret_type )
        add_slot_to_reg(" load self" , message , :receiver , ret )
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


  class CodeBuilder < Builder

    attr_reader :built
    def initialize(compiler, for_source)
      super
      @built = nil
    end

    def build(&block)
      super
      @built
    end

    # CodeBuilder stores the code.
    # The code can be access through the @built instance, and is returned
    # from build method
    def add_code(ins)
      if(@built)
        @built << ins
      else
        @built = ins
      end
    end
  end

  # A CompilerBuilder adds the generated code to the MethodCompiler.
  #
  class CompilerBuilder < Builder
    # add code straight to the compiler
    def add_code(ins)
      return @compiler.add_code(ins)
    end
  end

end

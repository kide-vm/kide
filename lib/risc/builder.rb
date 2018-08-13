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
    # A general "_reg"/"_obj" or "_tmp" at the end of the name will be removed
    # An error is raised if the symbol/object can not be inferred
    def infer_type( name )
      as_string = name.to_s
      parts = as_string.split("_")
      if(parts.last == "reg"  or parts.last == "obj" or parts.last == "tmp")
        parts.pop
        as_string = parts.join("_")
      end
      as_string = "word" if as_string == "name"
      as_string = "message" if as_string == "next_message"
      as_string = "message" if as_string == "caller"
      as_string = "named_list" if as_string == "arguments"
      sym = as_string.camelise.to_sym
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
    def if_minus( label )
      @source_used = true
      add_code Risc::IsMinus.new(@source , label)
    end
    def branch( label )
      @source_used = true
      add_code Risc::Branch.new(@source, label)
    end

    # to avoid many an if, it can be candy to swap variable names.
    # but since the names in the builder are not variables, we need this method
    # as it says, swap the two names around. Names must exist
    def swap_names(left , right)
      l = @names[left]
      r = @names[right]
      raise "No such name #{left}" unless l
      raise "No such name #{right}" unless r
      @names[left] = r
      @names[right] = l
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
      to.builder = self    # esecially div10 comes in without having used builder
      from.builder = self  # not named regs, different regs ==> silent errors
      build do
        space << Parfait.object_space
        to << space[:next_integer]
        integer_tmp << to[:next_integer]
        space[:next_integer] << integer_tmp
        to[Parfait::Integer.integer_index] << from
      end
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

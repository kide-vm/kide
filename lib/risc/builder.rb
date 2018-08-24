module Risc

  # A Builder is used to generate code, either by using it's api, or dsl
  #
  # The code is added to the method_compiler.
  #
  class Builder

    attr_reader :built , :compiler

    # pass a compiler, to which instruction are added (usually)
    # second arg determines weather instructions are added (default true)
    # call build with a block to build
    def initialize(compiler, for_source)
      raise "no compiler" unless compiler
      @compiler = compiler
      @source = for_source
      @source_used = false
      @names = {}
    end

    # make the magic: convert incoming names into registers that have the
    # type set according to the name (using resolve_type)
    # anmes are stored, so subsequent calls use the same register
    def method_missing(name , *args)
      super if args.length != 0
      name = name.to_s
      return @names[name] if @names.has_key?(name)
      if name == "message"
        return Risc.message_reg.set_builder(self)
      end
      if name.index("label")
        reg = Risc.label( @source , "#{name}_#{object_id}")
        @source_used = true
      else
        last_char = name[-1]
        name = name[0 ... -1]
        if last_char == "!" or last_char == "?"
          if @names.has_key?(name)
            return @names[name] if last_char == "?"
            raise "Name exists before creating it #{name}#{last_char}"
          end
        else
          raise "Must create (with ! or ?) before using #{name}#{last_char}"
        end
        type = infer_type(name )
        reg = @compiler.use_reg( type.object_class.name ).set_builder(self)
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
      if( ["reg" , "obj" , "tmp" , "self" , "const", "1" , "2"].include?( parts.last ) )
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
      left , right = left.to_s , right.to_s
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
    # build result is added to compiler directly
    #
    def build(&block)
      instance_eval(&block)
    end

    # add code straight to the compiler
    def add_code(ins)
      @compiler.add_code(ins)
      return ins
    end

    # move a machine int from register "from" to a Parfait::Integer in register "to"
    # have to grab an integer from space and stick it in the "to" register first.
    def add_new_int( source , from, to )
      to.set_builder( self )    # esecially div10 comes in without having used builder
      from.set_builder( self )  # not named regs, different regs ==> silent errors
      build do
        factory! << Parfait.object_space.get_factory_for(:Integer)
        to << factory[:next_object]
        integer_2! << to[:next_integer]
        factory[:next_object] << integer_2
        to[Parfait::Integer.integer_index] << from
      end
    end
  end

end

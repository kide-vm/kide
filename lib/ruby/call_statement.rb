module Ruby

  # A CallStatement is the abstraction of Send and Yield. The two are really
  # much more similar than different.
  #
  # A CallStatement has a name, receiver and arguments
  #
  # Using the "vool_brother" we can create the right Vool class for it.
  # Arguments in vool must be simple, so any complex expressions get
  # hoisted and assigned to temporary variables.
  #
  class CallStatement < Statement
    attr_reader :name , :receiver , :arguments

    def initialize(name , receiver , arguments )
      @name , @receiver , @arguments = name , receiver , arguments
      @arguments ||= []
    end

    # we "normalize" or flatten any complex argument expressions into a list
    def to_vool
      statements = Vool::Statements.new([])
      arguments = []
      @arguments.each_with_index do |arg , index |
        normalize_arg(arg , arguments , statements)
      end
      if statements.empty?
        return vool_brother.new(@name, @receiver.to_vool , arguments)
      else
        statements << vool_brother.new(@name, @receiver.to_vool , arguments)
        return statements
      end
    end

    # this is called for each arg and if the arg is not constant or Variable
    # we create a tmp variable and assign to that, hoising all the calls.
    # the effect is of walking the call tree now,
    # rather than using a stack to do that at runtime
    def normalize_arg(arg , arguments , statements)
      vool_arg = arg.to_vool
      if arg.is_a?(Constant)
        arguments << vool_arg
        return
      end
      if( vool_arg.is_a?(Vool::Statements))
        while(vool_arg.length > 1)
          statements << vool_arg.shift
        end
        vool_arg = vool_arg.shift
      end
      assign = Vool::LocalAssignment.new( "tmp_#{arg.object_id}".to_sym, vool_arg)
      statements << assign
      arguments << Vool::LocalVariable.new(assign.name)
    end

  end
end

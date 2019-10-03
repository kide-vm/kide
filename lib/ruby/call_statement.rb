module Ruby

  # A CallStatement is the abstraction of Send and Yield. The two are really
  # much more similar than different.
  #
  # A CallStatement has a name, receiver and arguments
  #
  # Using the "sol_brother" we can create the right Sol class for it.
  # Arguments in sol must be simple, so any complex expressions get
  # hoisted and assigned to temporary variables.
  #
  class CallStatement < Statement
    attr_reader :name , :receiver , :arguments

    def initialize(name , receiver , arguments )
      @name , @receiver , @arguments = name , receiver , arguments
      @arguments ||= []
    end

    # we "normalize" or flatten any complex argument expressions into a list
    def to_sol
      statements = Sol::Statements.new([])
      receiver = normalize_arg(@receiver , statements)
      arguments = []
      @arguments.each_with_index do |arg , index |
        arguments << normalize_arg(arg , statements)
      end
      if statements.empty?
        return sol_brother.new(@name, receiver , arguments)
      else
        statements << sol_brother.new(@name, receiver , arguments)
        return statements
      end
    end

    # this is called for each arg and if the arg is not constant or Variable
    # we create a tmp variable and assign to that, hoising all the calls.
    # the effect is of walking the call tree now,
    # rather than using a stack to do that at runtime
    def normalize_arg(arg , statements)
      sol_arg = arg.to_sol
      return sol_arg if sol_arg.is_a?(Sol::Expression)
      if( sol_arg.is_a?(Sol::Statements))
        while(sol_arg.length > 1)
          statements << sol_arg.shift
        end
        sol_arg = sol_arg.shift
      end
      assign = Sol::LocalAssignment.new( "tmp_#{arg.object_id}".to_sym, sol_arg)
      statements << assign
      return Sol::LocalVariable.new(assign.name)
    end

  end
end

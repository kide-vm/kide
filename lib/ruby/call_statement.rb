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

    def normalize_arg(arg , arguments , statements)
      if arg.is_a?(Constant) and !arg.is_a?(CallStatement)
        arguments << arg.to_vool
        return
      end
      assign = Vool::LocalAssignment.new( "tmp_#{arg.object_id}".to_sym, arg.to_vool)
      statements << assign
      arguments << Vool::LocalVariable.new(assign.name)
    end

  end
end

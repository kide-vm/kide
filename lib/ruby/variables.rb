module Ruby
  class Variable < Statement
    attr_reader :name

    def initialize name
      @name = name
    end

    def to_vool
      vool_brother.new(@name)
    end
  end

  class LocalVariable < Variable
    def to_s
      name.to_s
    end
  end

  class InstanceVariable < Variable

    # used to collect type information
    def add_ivar( array )
      array << @name
    end
    def to_s
      "@#{name}"
    end
  end

  class ClassVariable < Variable
  end

  class ModuleName < Variable
  end
end

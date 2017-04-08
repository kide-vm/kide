module Vool
  module Named
    attr_reader :name
    def initialize name
      @name = name
    end
  end

  class LocalVariable < Statement
    include Named
  end

  class InstanceVariable < Statement
    include Named
    # used to collect type information
    def add_ivar( array )
      array << @name
    end
  end

  class ClassVariable < Statement
    include Named
  end

  class ModuleName < Statement
    include Named
  end
end

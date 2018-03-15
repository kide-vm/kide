module Vool

  class Assignment < Statement
    attr_reader :name , :value
    def initialize(name , value )
      @name , @value = name , value
    end

    def normalize()
      raise "not named left #{name.class}" unless @name.is_a?(Symbol)
      raise "unsupported right #{value}" unless @value.is_a?(Named) or
              @value.is_a?(SendStatement) or @value.is_a?(Constant)
      self
    end

    def collect(arr)
      @value.collect(arr)
      super
    end
  end

  class IvarAssignment < Assignment
    # used to collect type information
    def add_ivar( array )
      array << @name
    end

    def to_mom( method )
      @value.slot_class.new([:message , :receiver , @name] , @value.to_mom(method))
    end

  end
end

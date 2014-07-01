module Virtual
  class Mystery < Value
    def initialize 
    end

    def as type
      type.new
    end

  end

  class Singleton < Value
  end
  class TrueValue < Singleton
  end
  class FalseValue < Singleton
  end
  class NilValue < Singleton
  end
end

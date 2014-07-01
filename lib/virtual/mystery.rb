module Virtual
  class Mystery < Value
    def initialize 
    end

    def as type
      type.new
    end

  end

  class TrueValue < Value
  end
  class FalseValue < Value
  end
  class NilValue < Value
  end
end

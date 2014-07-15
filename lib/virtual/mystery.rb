require_relative "constants"

module Virtual
  class Mystery < Value
    def initialize 
    end

    def as type
      type.new
    end

  end

  class TrueValue < Constant
  end
  class FalseValue < Constant
  end
  class NilValue < Constant
  end
end

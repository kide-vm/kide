module Vool
  class IntegerStatement < Statement
    attr_accessor :value
    def initialize(value)
      @value = value
    end
  end
  class FloatStatement < Statement
    attr_accessor :value
    def initialize(value)
      @value = value
    end
  end
  class TrueStatement < Statement
  end
  class FalseStatement < Statement
  end
  class NilStatement < Statement
  end
  class SelfStatement < Statement
  end
  class StringStatement < Statement
    attr_accessor :value
    def initialize(value)
      @value = value
    end
  end
  class SymbolStatement < StringStatement
  end
end

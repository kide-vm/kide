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
  class StringStatement < Statement
    attr_accessor :value
    def initialize(value)
      @value = value
    end
  end
  class NameStatement < Statement
    attr_accessor :value
    alias :name :value
    def initialize(value)
      @value = value
    end
  end
end

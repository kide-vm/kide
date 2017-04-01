module Vool
  class Assignment < Statement
    attr_accessor :name , :value
    def initialize(n = nil , v = nil )
      @name , @value = n , v
    end
  end

  class FieldDef < Statement
    attr_accessor :name , :type , :value
  end

end

module Vool
  class Statements < Statement
    attr_accessor :statements
    def initialize(statements)
      @statements = statements
    end
  end

  class ScopeStatement < Statements
  end
end

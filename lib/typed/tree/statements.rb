module Typed
  class Statements < Statement
    attr_accessor :statements
    def to_s
      return "" unless statements
      statements.collect() { |s| s.to_s }.join
    end
  end
end

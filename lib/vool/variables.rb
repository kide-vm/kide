module Vool
  module Named
    attr_accessor :name
    def initialize name
      @name = name
    end
  end

  class LocalVariable < Statement
    include Named
  end
end

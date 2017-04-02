module Vool
  class SendStatement < Statement
    attr_accessor :name , :receiver , :arguments
    def initialize(name)
      @name = name
      @arguments = []
    end
  end
end

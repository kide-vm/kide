module Vool
  class SendStatement < Statement
    attr_reader :name , :receiver , :arguments

    def initialize(name , receiver , arguments = [])
      @name , @receiver , @arguments = name , receiver , arguments
    end
  end
end

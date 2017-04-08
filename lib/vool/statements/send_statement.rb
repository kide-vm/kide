module Vool
  class SendStatement < Statement
    attr_reader :name , :receiver , :arguments

    def initialize(name , receiver , arguments = [])
      @name , @receiver , @arguments = name , receiver , arguments
    end

    def collect(arr)
      @receiver.collect(arr)
      @arguments.collect(arr)
      super
    end

  end
end

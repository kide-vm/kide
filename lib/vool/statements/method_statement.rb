module Vool
  class MethodStatement
    attr_reader :name, :args , :body

    def initialize( name , args , body)
      @name , @args , @body = name , args , (body || [])
    end

    def collect(arr)
      @args.collect(arr)
      @body.collect(arr) 
      super
    end

  end
end

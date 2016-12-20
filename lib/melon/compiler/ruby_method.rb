module Melon

  class RubyMethod

    attr_reader :name , :args_type , :body
    
    def initialize(name , args_type , body )
      @name , @args_type , @body = name , args_type , body
    end

  end
end

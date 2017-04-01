module Vool
  class ClassStatement
    attr_reader :name, :super_class_name , :body

    def initialize( name , supe , body)
      @name , @super_class_name , @body = name , supe , body
    end

  end
end

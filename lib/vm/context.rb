
module Vm
  
  #currently just holding the object_space in here so we can have global access
  class Context
    
    def initialize object_space
      @object_space = object_space
      @locals = {}
    end
    attr_reader :attributes ,:object_space

    attr_accessor :current_class , :locals , :function
    
  end
end

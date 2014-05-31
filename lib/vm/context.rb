require "support/hash_attributes"
module Vm
  
  #currently just holding the object_space in here so we can have global access
  class Context
    # Make hash attributes to object attributes
    include Support::HashAttributes
    
    def initialize object_space
      @attributes = {}
      @attributes[:object_space] = object_space
    end
    attr_reader :attributes
  end
end

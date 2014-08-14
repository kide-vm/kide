module Sof

  class Occurence
    def initialize object , number , level
      @object = object
      @number = number
      @level = level
    end
    attr_reader   :object , :number
    attr_accessor :level
  end

end

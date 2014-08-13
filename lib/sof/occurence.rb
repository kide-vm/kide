module Sof

  class Occurence
    def initialize object , level , number
      @number = number
      @object = object
      @level = level
    end
    attr_reader   :object , :number
    attr_accessor :level
  end

end

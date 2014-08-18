module Sof

  class Occurence
    def initialize object , level
      @object = object
      @level = level
    end
    attr_reader   :object
    attr_accessor :level , :referenced
  end

end

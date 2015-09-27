module Parfait
  class Variable < Object
    def initialize type , name , value = nil
      @type , @name , @value = type , name , value
      @value = 0 if @type == :int and value == nil
    end
    attributes [:type , :name, :value]
  end
end

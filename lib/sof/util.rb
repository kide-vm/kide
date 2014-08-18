module Sof
  module Util
    def is_value? o
      return true if o == true
      return true if o == false
      return true if o == nil
      return true if o.class == Fixnum
      return true if o.class == Symbol
      return true if o.class == String
      return false
    end

    def get_value(object,name)
      object.instance_variable_get "@#{name}".to_sym
    end

    def attributes_for object
      atts = object.instance_variables.collect{|i| i.to_s[1..-1].to_sym } # chop of @
      atts - Volotile.attributes(object.class)
    end
    
  end
end

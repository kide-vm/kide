module Virtual
  
  # the virtual machine is implemented in values (a c++ version of oo). 
  # Values have types which are represented as classes, instances of Type to be precise

  # Values must really be Constants or Variables, ie have a storage space

  class Walue
    def type
      raise "abstract called for #{self.class}"
    end
    def == other
      return false unless other.class == self.class 
      Sof::Util.attributes(self).each do |a|
        begin
          left = send(a)
        rescue NoMethodError
          next  # not using instance variables that are not defined as attr_readers for equality
        end
        begin
          right = other.send(a)
        rescue NoMethodError
          return false
        end
        return false unless left.class == right.class 
        return false unless left == right
      end
      return true
    end
    private #can't instantiate, must be constant or variable
    def initialize
    end
  end
end

require_relative "slot"
module Virtual
  # our machine is made up of objects, some of which are code, some data
  #
  # during compilation objects are module Virtual objects, but during execution they are not scoped
  # 
  # functions on these classes express their functionality as function objects
  class Object
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

    def inspect
      to_yaml
    end

    def self.space
      if defined? @@space
        @@space
      else
        @@space = ::Boot::BootSpace.new
      end
    end
  end
  
  class Layout < Object
    def initialize members
      @members = members
    end
    def attributes
      super << :members
    end
  end

  class Class < Object
    def initialize name , sup = :Object
      @name = name
      @super_class = sup
    end
  end
end

module Virtual
  # our machine is made up of objects, some of which are code, some data
  #
  # during compilation objects are module Virtual objects, but during execution they are not scoped
  # 
  # functions on these classes express their functionality as function objects
  class Object
    def initialize
      @layout = Layout.new( attributes )
    end
    def attributes
      [:layout]
    end
    def == other
      return false unless other.class == self.class 
      attributes.each do |a|
        left = send(a)
        right = other.send(a)
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

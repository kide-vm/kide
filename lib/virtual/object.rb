module Virtual
  # our machine is made up of objects, some of which are code, some data
  #
  # during compilation objects are module Virtual objects, but during execution they are not scoped
  # 
  # functions on these classes express their functionality as function objects
  class Object
    def initialize
      @layout = Layout.new([:layout])
    end
    def attributes
      raise "abstract #{self}"
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
  end
  
  class Layout < Object
    def initialize members
      @members = members
    end
    def attributes
      [:members]
    end
  end

  class Class < Object
    def initialize name , sup = :Object
      @name = name
      @super_class = sup
    end
  end

end

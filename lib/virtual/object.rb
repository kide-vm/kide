module Virtual
  # our machine is made up of objects, some of which are code, some data
  #
  # during compilation objects are module Virtual objects, but during execution they are not scoped
  # 
  # So compiling/linking/assembly turns ::virtual objects into binary that represents ruby objects at runtime
  # The equivalence is listed below (i'll try and work on clearer correspondence later)
  #  ::Virtual            Runtime / parfait
  #   Object                  Object
  #   BootClass               Class
  #   MetaClass               self/Object
  #   BootSpace               ObjectSpace
  #   CompiledMethod          Function
  #   (ruby)Array             Array
  #         String            String
  class Object
    # This could be in test, as it is used only there
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
      Sof::Writer.write(self)
    end
  end
end

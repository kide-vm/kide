require_relative "type"

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
    def initialize
      @position = -1
      @length = -1
    end
    attr_accessor :position , :length , :layout
    def position
      raise "position accessed but not set at #{length} for #{self.objekt}" if @position == -1
      @position
    end
    
    def inspect
      Sof::Writer.write(self)
    end

    @@EMPTY =  { :names => [] , :types => []}
    def layout
      raise "Find me #{self}"
      self.class.layout
    end
    def self.layout
      @@EMPTY
    end
    # class variables to have _identical_ objects passed back (stops recursion)
    @@ARRAY =  { :names => [] , :types => []}
#    @@HASH = { :names => [:keys,:values] , :types => [Virtual::Reference,Virtual::Reference]}
#    @@CLAZZ = { :names => [:name , :super_class_name , :instance_methods] , :types => [Virtual::Reference,Virtual::Reference,Virtual::Reference]}
#    @@SPACE = { :names => [:classes,:objects] , :types => [Virtual::Reference,Virtual::Reference]}

    def layout_for(object)
      case object
      when Array , Symbol , String , Virtual::CompiledMethod , Virtual::Block , Virtual::StringConstant
        @@ARRAY
      when Hash
        @@HASH.merge :keys => object.keys , :values => object.values 
      when Virtual::BootClass
        @@CLAZZ
      when Virtual::BootSpace
        @@SPACE
      else
        raise "linker encounters unknown class #{object.class}"
      end
    end
    
  end
end
Parfait::Hash.class_eval do
  @@HASH = { :names => [:keys,:values] , :types => [Virtual::Reference,Virtual::Reference]}
  def layout
    @@HASH
  end
end
Array.class_eval do
  def layout
    Virtual::Object.layout
  end
end
Symbol.class_eval do
  def layout
    Virtual::Object.layout
  end
end

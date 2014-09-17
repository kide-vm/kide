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
      @position = nil
      @length = -1
    end
    attr_accessor  :length , :layout
    def position
      raise "position accessed but not set at #{length} for #{self.inspect}" if @position == nil
      @position
    end
    def set_position pos
      # resetting of position used to be error, but since relink and dynamic instruction size it is ok. in measures
      if @position != nil and ((@position - pos).abs > 15)
        raise "position set again #{pos}!=#{@position} for #{self}" 
      end
      @position = pos
    end
    def inspect
      Sof::Writer.write(self)
    end
    def mem_length
      raise "abstract #{self}"
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
    # objects only come in lengths of multiple of 8 words
    # but there is a constant overhead of 2 words, one for type, one for layout
    # and as we would have to subtract 1 to make it work without overhead, we now have to add 7
    def padded len
      a = 32 * (1 + (len + 7)/32 )
      #puts "#{a} for #{len}"
      a
    end

    def padded_words words
      padded(words*4) # 4 == word length, a constant waiting for a home
    end
  end
end
Parfait::Hash.class_eval do
  HASH = { :names => [:keys,:values] , :types => [Virtual::Reference,Virtual::Reference]}
  def layout
    HASH
  end
  def set_position pos
    @position = pos
  end
  def position
    @position
  end
  def mem_length
    Virtual::Object.new.padded_words(2)
  end
end
Array.class_eval do
  def layout
    Virtual::Object.layout
  end
  def set_position pos
    @position = pos
  end
  def position
    @position
  end
  def mem_length
    Virtual::Object.new.padded_words(length())
  end
end
Symbol.class_eval do
  def set_position pos
    @position = pos
  end
  def position
    @position
  end
  def layout
    Virtual::Object.layout
  end
  def mem_length
    Virtual::Object.new.padded(1 + to_s.length())
  end
end
String.class_eval do
  def set_position pos
    @position = pos
  end
  def position
    @position
  end
  def layout
    Virtual::Object.layout
  end
  def mem_length
    Virtual::Object.new.padded(1 + length())
  end
end

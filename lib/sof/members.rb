module Sof
  
  class Members
    def initialize root
      @root = root
      @counter = 1
      @objects = {}
      add(root ,0 )
    end

    def add object , level
      if( @objects.has_key?(object) )
        occurence = @objects.get(object)
        occurence.level = level if occurence.level > level
      else
        o = Occurence.new( object , @counter , level )
        @objects[object] = o
        c = @counter
        @counter = @counter + 1
        object.attributes.each do a
          val = object.send a
          add(val , level + 1)
        end
      end
    end

    def write
      string = ""
      output string , @root
    end

    def output string , object
      occurence = @objects[object]
      indent = " " * occurence.level
      string += indent
      if(object.respond_to? :to_sof)
        string += object.to_sof + "\n"
      else
        string += "!" + object.class.name + "\n"
        indent += " "
        object.attributes.each do a
          val = object.send a
          output( string , val)
        end
      end
    end

    def self.write object
      members = Members.new object
      members.write
    end
  end
end

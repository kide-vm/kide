module Risc

  #  collect anything that is in the space and reachable (linker constants)
  #
  # The place we collect in is the position map in Position class
  module Collector
    # Collect all object that need to be added to the binary
    # This means the object_space and aby constants the linker has
    # we call keep on each object, see there for details
    # return all positions
    def self.collect_space(linker)
      keep Parfait.object_space
      linker.constants.each do |obj|
        keep(obj)
      end
      Position.positions
    end

    # keep "collects" the object for "keeping". Such objects get written to binary
    # keeping used to be done by adding to a hash, but now the object is
    # given a position, and the Position class has a hash of all positions
    # (the same hash has all objects, off course)
    def self.keep( object)
      collection = []
      mark_1k( object , 0 , collection)
      collection.each do |obj|
        #puts "obj  #{obj.object_id}"
        keep(obj)
      end
    end

    # marking object that make up the binary.
    # "Only" up to 1k stack depth, collect object that make up the "border"
    #
    # Collection is an empty arry that is passed on. Objects below 1k get added
    # So basically it "should" be a return, but then we would keep creating and adding
    # arrays, most of which would be empty
    def self.mark_1k(object , depth , collection)
      return if object.nil?
      if depth > 1000
        collection << object
        return
      end
      return unless position!( object )
      return unless object.respond_to? :has_type?
      type = object.get_type
      mark_1k(type  , depth + 1 , collection)
      return if object.is_a? Symbol
      type.names.each do |name|
        mark_1k(name , depth + 1, collection)
        inst = object.get_instance_variable name
        #puts "getting name #{name}, val=#{inst} #{inst.object_id}"
        mark_1k(inst , depth + 1, collection)
      end
      if object.is_a? Parfait::List
        object.each do |item|
          mark_1k(item , depth + 1, collection)
        end
      end
    end

    # Give the object a position. Position class keeps a list of all positions
    # and associated objects. The actual position is determined later, here a
    # Position object is assigned.
    #
    # All Objects that end up in the binary must have a Position.
    #
    # return if the position was assigned (true) or had been assigned already (false)
    def self.position!( objekt )
      return false if Position.set?(objekt)
      return true if objekt.is_a? ::Integer
      return true if objekt.is_a?( Risc::Label)
      #puts "ADD  #{objekt.class.name}"
      unless objekt.is_a?( Parfait::Object) or objekt.is_a?( Symbol)
        raise "adding non parfait #{objekt.class}:#{objekt}"
      end
      #raise "Method #{objekt.name}" if objekt.is_a? Parfait::CallableMethod
      Position.get_or_create(objekt)
      true
    end

  end
end

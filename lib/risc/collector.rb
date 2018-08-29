module Risc

  #  collect anything that is in the space but and reachable from init
  #
  # The place we collect in is the position map in Position class
  module Collector
    def self.collect_space(linker)
      keep Parfait.object_space , 0
      linker.constants.each do |obj|
        keep(obj,0)
      end
      Position.positions
    end

    def self.keep( object , depth )
      return if object.nil?
      return unless add_object( object , depth )
      return unless object.respond_to? :has_type?
      type = object.get_type
      keep(type  , depth + 1)
      return if object.is_a? Symbol
      type.names.each do |name|
        keep(name , depth + 1)
        inst = object.get_instance_variable name
        keep(inst , depth + 1)
      end
      if object.is_a? Parfait::List
        object.each do |item|
          keep(item , depth + 1)
        end
      end
    end

    # Objects are data and get assembled after functions
    def self.add_object( objekt , depth)
      return false if Position.set?(objekt)
      return true if objekt.is_a? Fixnum
      return true if objekt.is_a?( Risc::Label)
      #puts message(objekt , depth)
      #puts "ADD #{objekt.inspect}, #{objekt.name}" if objekt.is_a? Parfait::CallableMethod
      unless objekt.is_a?( Parfait::Object) or objekt.is_a?( Symbol)
        raise "adding non parfait #{objekt.class}:#{objekt}"
      end
      #raise "Method #{objekt.name}" if objekt.is_a? Parfait::CallableMethod
      Position.get_or_create(objekt)
      true
    end

    def self.message(object , depth)
      msg =  "adding #{depth}#{' ' * depth}:"
      if( object.respond_to?(:rxf_reference_name))
        msg + object.rxf_reference_name.to_s
      else
        msg + object.class.name
      end
    end
  end
end

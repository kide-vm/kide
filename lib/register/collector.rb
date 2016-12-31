module Register

  #  collect anything that is in the space but and reachable from init
  module Collector
    def collect_space
      @objects = {}
      keep Parfait.object_space , 0
      constants.each {|obj| keep(obj,0)}
      @objects
    end

    def keep( object , depth )
      return if object.nil?
      return unless add_object( object , depth )
      # probably should make labels or even instructions derive from Parfait::Object, but . .
      if object.is_a? Register::Label
        object.each_label { |l| self.add_object(l ,depth)}
      end
      return unless object.respond_to? :has_type?
      type = object.get_type
      keep(type  , depth + 1)
      return if object.is_a? Symbol
      type.names.each do |name|
        keep(name , depth + 1)
        #puts "Keep #{name} for #{object.class}"
        inst = object.get_instance_variable name
        keep(inst , depth + 1)
      end
      if object.is_a? Parfait::List
        object.each do |item|
          #puts "Keep item "
          keep(item , depth + 1)
        end
      end
    end

    # Objects are data and get assembled after functions
    def add_object( objekt , depth)
      return false if @objects[objekt.object_id]
      return true if objekt.is_a? Fixnum
      #puts message(objekt , depth)
      #puts "ADD #{objekt.inspect}, #{objekt.name}" if objekt.is_a? Parfait::TypedMethod
      unless objekt.is_a?( Parfait::Object) or objekt.is_a?( Symbol) or objekt.is_a?( Register::Label)
        raise "adding non parfait #{objekt.class}"
      end
      #raise "Method #{objekt.name}" if objekt.is_a? Parfait::TypedMethod
      @objects[objekt.object_id] = objekt
      true
    end

    def message(object , depth)
      msg =  "adding #{depth}#{' ' * depth}:"
      if( object.respond_to?(:sof_reference_name))
        msg + object.sof_reference_name.to_s
      else
        msg + object.class.name
      end
    end
  end
end

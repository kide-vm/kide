module Register

  #  collect anything that is in the space but and reachable from init
  module Collector
    def collect
      self.objects.clear
      keep Parfait::Space.object_space , 0
      constants.each {|o| keep(o,0)}
    end

    def keep object , depth
      return if object.nil?
      #puts "adding #{' ' * depth}:#{object.class}"
      #puts "ADD #{object.first.class}, #{object.last.class}" if object.is_a? Array
      return unless self.add_object object
      # probably should make labels or even instructions derive from Parfait::Object, but . .
      if  object.is_a? Register::Label
        object.each_label { |l| self.add_object(l)}
      end
      return unless object.respond_to? :has_type?
      type = object.get_type
      keep(type  , depth + 1)
      return if object.is_a? Symbol
      type.instance_names.each do |name|
        #puts "Keep #{name} for #{object.class}"
        inst = object.get_instance_variable name
        keep(inst , depth + 1)
      end
      if object.is_a? Parfait::Indexed
        object.each do |item|
          #puts "Keep item "
          keep(item , depth + 1)
        end
      end
    end
  end
end

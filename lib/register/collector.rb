module Register

  #  collect anything that is in the space but and reachable from init
  module Collector
    def collect
      # init= Parfait::Space.object_space.get_class_by_name("Kernel").get_instance_method "__init__"
      self.objects.clear
      keep Parfait::Space.object_space , 0
      constants.each {|o| keep(o,0)}
    end

    def keep object , depth
      return if object.nil?
      #puts "adding #{' ' * depth}:#{object.class}"
      #puts "ADD #{object.first.class}, #{object.last.class}" if object.is_a? Array
      return unless self.add_object object
      return unless object.respond_to? :has_layout?
      layout = object.get_layout
      keep(layout  , depth + 1)
      return if object.is_a? Symbol
      layout.instance_names.each do |name|
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

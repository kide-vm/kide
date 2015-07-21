module Virtual

  #  collect anything that is in the space but and reachable from init
  class Collector
    def run
      # init= Parfait::Space.object_space.get_class_by_name("Kernel").get_instance_method "__init__"
      keep Parfait::Space.object_space
    end

    def keep object
      return if object.nil?
      return unless Virtual.machine.add_object object
      #puts "adding #{object.class}"
      return unless object.respond_to? :has_layout?
      if( object.is_a? Parfait::Method)
        object.source.constants.each{|c|
          puts "keeping constant #{c.class}"
          keep(c)
        }
      end
      layout = object.get_layout
      keep layout
      #puts "Layout #{layout.object_class.name} #{Machine.instance.objects.has_key?(layout.object_id)}"
      layout.object_instance_names.each do |name|
        inst = object.get_instance_variable name
        keep inst
      end
      if object.is_a? Parfait::List
        object.each do |item|
          keep item
        end
      end
    end
  end
end

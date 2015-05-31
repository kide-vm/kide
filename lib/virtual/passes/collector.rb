module Virtual

  # garbage collect anything that is in the space but not reachable from init
  class Collector
    def run
      @keepers = []
      init= Parfait::Space.object_space.get_class_by_name("Kernel").get_instance_method "__init__"
      keep init
    end

    def keep object
      return if @keepers.include? object
      layout = object.get_layout
      begin
        puts "Object #{object.class} #{Parfait::Space.object_space.objects.include?(object)}"
        puts "Object #{layout.object_id} #{Parfait::Space.object_space.objects.include?(layout)}"
        keep layout
      rescue => e
        puts "for #{object.name}"
        raise e
      end
      layout.each do |name|
        inst = object.instance_variable_get "@#{name}".to_sym
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

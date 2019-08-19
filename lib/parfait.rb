# Parfait is the ruby runtime
module Parfait
  TYPE_INDEX = 0

  class Object
    def self.memory_size
      8
    end
    def self.type_length
      1
    end
    def self.new( *args )
      object = self.allocate
      # have to grab the class, because we are in the ruby class not the parfait one
      cl = Parfait.object_space.get_class_by_name( self.name.split("::").last.to_sym)
      # and have to set the type before we let the object do anything. otherwise boom
      object.set_type cl.instance_type
      object.send :initialize , *args
      object
    end

  end
  ["object" , "data_object","integer","factory" ].each do |file_name|
    path = File.expand_path(  "../parfait/#{file_name}.rb" , __FILE__)
    module_eval( File.read path)
  end
end

require_relative "parfait/behaviour"
require_relative "parfait/class"
require_relative "parfait/meta_class"
require_relative "parfait/list"
require_relative "parfait/word"
require_relative "parfait/binary_code"
require_relative "parfait/callable"
require_relative "parfait/block"
require_relative "parfait/callable_method"
require_relative "parfait/vool_method"
require_relative "parfait/dictionary"
require_relative "parfait/type"
require_relative "parfait/cache_entry"
require_relative "parfait/message"
require_relative "parfait/named_list"
require_relative "parfait/space"

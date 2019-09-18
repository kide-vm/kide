# Parfait is the ruby runtime
module Parfait
  TYPE_INDEX = 0
end

require_relative "parfait/object"
require_relative "parfait/data_object"
require_relative "parfait/integer"
require_relative "parfait/factory"
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
require_relative "parfait/space"
module Parfait
  # temporary shorthand getter for the space
  # See implementation, space is now moved to inside the Object class
  # (not module anymore), but there is a lot of code (about 100, 50/50 li/test)
  # still calling this old version and since it is shorter . . .
  def self.object_space
    Object.object_space
  end
  
  class Object
    # redefine the runtime version
    def self.new( *args )
      object = self.allocate
      # have to grab the class, because we are in the ruby class not the parfait one
      cl = Parfait.object_space.get_class_by_name( self.name.split("::").last.to_sym)
      # and have to set the type before we let the object do anything. otherwise boom
      object.set_type cl.instance_type
      object.send :initialize , *args
      object
    end

    # Setter fo the boot process, only at runtime.
    # only one space exists and it is generated at compile time, not runtime
    def self.set_object_space( space )
      @object_space = space
    end

  end
end

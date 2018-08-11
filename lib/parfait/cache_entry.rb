# For dynamic calls (ie method calls where the method can not be determined at compile time)
# we resolve the method at runtime, and then cache it. Aaron has shown that over 99%
# of call sites are type stable, so one cache entry at the moment
#
# A cache entry stores the type of the object and the CallableMethod that is to be called
# This is used in DynamicCall, see there
#
module Parfait
  class CacheEntry < Object

    attr :type, :cached_type, :cached_method

    def initialize(type , method)
      self.cached_type = type
      self.cached_method = method
    end

    def to_s
      "CacheEntry" + "#{cached_method&.name}"
    end
  end
end

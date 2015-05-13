require "parfait/value"
require "parfait/object"
require "parfait/module"
require "parfait/class"
require "parfait/dictionary"
require "parfait/list"
require "parfait/word"
require "parfait/message"
require "parfait/frame"
require "parfait/space"

# Below we define functions (in different classes) that are not part of the run-time
# They are used for the boot process, ie when this codes executes in the vm that builds salama

# To stay sane, we use the same classes that we use later, but "adapt" them to work in ruby
# This affects mainly memory layout

module FakeMem
  def initialize
    @memory = []
  end
end

class Parfait::Object
  include FakeMem
  def self.new_object *args
    #puts "I am #{self}"
    object = self.new(*args)
    object
  end
  def internal_object_length
    @memory.length
  end
  def internal_object_get(index)
    @memory[index]
  end
  def internal_object_set(index , value)
    @memory[index] = value
  end
  def internal_object_grow(index)
    @memory[index] = nil
  end
end
class Parfait::Class
end
class Parfait::List
  def length
    internal_object_length
  end
end

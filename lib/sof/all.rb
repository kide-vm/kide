require_relative "util"
require_relative "node"
require_relative "members"
require_relative "volotile"
require_relative "writer"
require_relative "array"
require_relative "hash"
require_relative "occurence"

Symbol.class_eval do
  def to_sof()
    ":#{to_s}"
  end
end
TrueClass.class_eval do
  def to_sof()
    "true"
  end
end
FalseClass.class_eval do
  def to_sof()
    "false"
  end
end
String.class_eval do
  def to_sof()
    "'" + self + "'"
  end
end
Fixnum.class_eval do
  def to_sof()
    to_s
  end
end

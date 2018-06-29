require_relative "builtin/compile_helper"
require_relative "builtin/space"
require_relative "builtin/integer"
require_relative "builtin/object"
require_relative "builtin/word"

module Risc
  module Builtin
    # classes have booted, now create a minimal set of functions
    # minimal means only that which can not be coded in ruby
    # Methods are grabbed from respective modules by sending the method name.
    # This should return the implementation of the method (ie a method object),
    # not actually try to implement it(as that's impossible in ruby)
    #
    def self.boot_functions( )
      space = Parfait.object_space
      # very fiddly chicken 'n egg problem. Functions need to be in the right order, and in fact we
      # have to define some dummies, just for the others to compile
      # TODO go through the virtual parfait layer and adjust function names to what they really are
      space_class = space.get_class
      space_class.instance_type.add_method Builtin::Space.send(:main, nil)

      obj = space.get_class_by_name(:Object)
      [ :get_internal_word , :set_internal_word , :_method_missing,
        :exit , :__init__].each do |f|
        obj.instance_type.add_method Builtin::Object.send(f , nil)
      end

      obj = space.get_class_by_name(:Word)
      [:putstring , :get_internal_byte , :set_internal_byte ].each do |f|
        obj.instance_type.add_method Builtin::Word.send(f , nil)
      end

      obj = space.get_class_by_name(:Integer)
      Risc.operators.each do |op|
        obj.instance_type.add_method Builtin::Integer.operator_method(op)
      end
      [:putint, :div4, :div10 , :<,:<= , :>=, :>].each do |f|   #div4 is just a forward declaration
        obj.instance_type.add_method Builtin::Integer.send(f , nil)
      end
    end

  end
end

module Parfait
  module MethodHelper
    def make_method(name = :meth , clazz = :Object)
      @obj = Parfait.object_space.get_type_by_class_name(clazz)
      @args = Parfait::Type.for_hash( { bar: :Integer , foo: :Type} , @obj.object_class)
      @frame = Parfait::Type.for_hash( { local_bar: :Integer , local_foo: :Type},@obj.object_class)
      @method = Parfait::CallableMethod.new( name , @obj , @args , @frame)
    end
  end
  class ParfaitTest < MiniTest::Test
    include MethodHelper

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @space = Parfait.object_space
    end
  end
  class BigParfaitTest < ParfaitTest
    def setup
      Parfait.boot!(Parfait.full_test_options)
      @space = Parfait.object_space
    end
  end
end

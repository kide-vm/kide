module Parfait
  class ParfaitTest < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @space = Parfait.object_space
    end
    def make_method
      @obj = Parfait.object_space.get_type_by_class_name(:Object)
      @args = Parfait::Type.for_hash( @obj.object_class , { bar: :Integer , foo: :Type})
      @frame = Parfait::Type.for_hash( @obj.object_class , { local_bar: :Integer , local_foo: :Type})
      @method = Parfait::CallableMethod.new( :meth , @obj , @args , @frame)
    end
  end
  class BigParfaitTest < ParfaitTest
    def setup
      Parfait.boot!(Parfait.full_test_options)
      @space = Parfait.object_space
    end
  end
end

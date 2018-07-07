require_relative "../helper"

module Parfait
  class ParfaitTest < MiniTest::Test

    def setup
      Parfait.boot!
      @space = Parfait.object_space
    end
    def make_method
      @obj = Parfait.object_space.get_class_by_name(:Object).instance_type
      @args = Parfait::Type.for_hash( @obj.object_class , { bar: :Integer , foo: :Type})
      @frame = Parfait::Type.for_hash( @obj.object_class , { local_bar: :Integer , local_foo: :Type})
      @method = Parfait::CallableMethod.new( @obj , :meth , @args , @frame)
    end
  end
end

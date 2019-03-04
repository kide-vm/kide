module Parfait
  def self.default_test_options
     {
       factory: 20,
     }
  end
  def self.interpreter_test_options
     {
       factory: 50,
     }
  end
  def self.full_test_options
     {
       factory: 1024,
     }
  end
end

module RubyX
  def self.default_test_options
     {
       parfait: Parfait.default_test_options
     }
  end
  def self.full_test_options
     {
       parfait: Parfait.full_test_options
     }
  end
  def self.interpreter_test_options
     {
       parfait: Parfait.interpreter_test_options,
       load_parfait: false ,
       platform: :interpreter
     }
  end
end

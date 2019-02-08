module Parfait
  def self.default_test_options
     {}
  end
end

module RubyX
  def self.default_test_options
     { parfait: Parfait.default_test_options}
  end
end

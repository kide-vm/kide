require_relative "../helper"
require "parslet/convenience"

# remove the line numbers on assert fails, so it's easy to copy paste the result as the expected result
Parslet::Slice.class_eval do
  def inspect
    '"'  + to_s + '"'
  end
end
# Included in parser test will create tests methods
module ParserHelper
  
  def self.included(base)
    base.send :include, InstanceMethods  #provides helpers and setup
    base.send :extend, ClassMethods   #gets the method creation going
  end
 
  module InstanceMethods
    def setup
      @parser    = Parser::Crystal.new
      @transform = Parser::Transform.new
    end

    # check that @string_input parses correctly to @parse_output
    def check_parse
      is = @parser.parse_with_debug(@string_input)
      assert_equal @parse_output , is
    end

    #check that @parse_output transforms to @transform_output
    def check_transform
      is = @transform.apply @parse_output
      #puts is.transform
      assert_equal @transform_output , is
    end

    # check that @string_input parses and transforms to @transform_output
    def check_ast
      syntax    = @parser.parse(@string_input)
      tree      = @transform.apply(syntax)
      # puts tree.inspect
      assert_equal @transform_output , tree
    end
  end

  module ClassMethods
    # this creates test methods dynamically. For each test_* method we create 
    # three test_*[ast/parse/transf] methods that in turn check the three phases.
    # runnable_methods is called by minitest to determine which tests to run
    def runnable_methods
      tests = []
      public_instance_methods(true).grep(/^test_/).map(&:to_s).each do |test|
        ["ast" , "transform" , "parse"].each do |what|
          name = "#{test}_#{what}"
          tests << name
          self.send(:define_method, name ) do
            send(test)
            send("check_#{what}")
          end
        end
      end
      tests
    end
   end
end

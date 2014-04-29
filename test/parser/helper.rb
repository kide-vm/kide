require_relative "../helper"

# Included in parser test will create tests methods
module ParserHelper
  
  def self.included(base)
    base.send :include, InstanceMethods  #provides helpers and setup
    base.send :extend, ClassMethods   #gets the method creation going
  end
 
  module InstanceMethods
    def setup
      @parser    = Parser::Composed.new
      @transform = Parser::Transform.new
    end

    # check that @string_input parses correctly to @parse_output
    def check_parse
      is = @parser.parse(@string_input)
      #puts is.inspect
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
    # this creates test methods dynamically. For each parse_* method we create 
    # three test_* methods that in turn check the three phases.
    # runnable_methods is called by minitest to determine which tests to run (ie normally test_*)
    def runnable_methods
      tests = []
      public_instance_methods(true).grep(/^parse_/).map(&:to_s).each do |parse|
        ["ast" , "transform" , "parse"].each do |what|
          name = "parse_#{what}"
          tests << name
          self.send(:define_method, name ) do
            send(parse)
            send("check_#{what}")
          end
        end
      end
      tests
    end
   end
end

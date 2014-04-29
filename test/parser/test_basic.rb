require_relative "helper"

class TestBasic < MiniTest::Test
  include ParserTest
  
  # this creates test methods dynamically , one for each file in runners directory
  def self.runnable_methods
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
  
  def parse_number
    @input    = '42 '
    @parse_output = {:integer => '42'}
    @transform_output = Parser::IntegerExpression.new(42)
    @parser = @parser.integer
  end

  def parse_name
    @input    = 'foo '
    @parse_output = {:name => 'foo'}
    @transform_output = Parser::NameExpression.new('foo')
    @parser = @parser.name
  end

  def parse_string
    @input    = <<HERE
"hello" 
HERE
    @parse_output =  {:string=>"hello"}
    @transform_output =  Parser::StringExpression.new('hello')
    @parser = @parser.string
  end

end
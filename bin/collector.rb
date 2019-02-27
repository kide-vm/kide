require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)

require "rubyx"
require "parser/current"
require "yaml"

# An experiment to find out how much ruby there is to achieve bootstrap
#
# currently (feb/2019) just over
# 173 classes
# 1.8k methods
# 13k sends
# 13 yields (250 blocks)
# 1 redo (to be avoided)
# 4 ensure
# 6 rescue
# 38 singleton classes (not in rubyx)
# 14 evals (different versions , and all problematic)
# and a whole list of every other possible ruby feature
class Walker < AST::Processor
  def initialize collector
    @collector = collector
  end

  def on_send node
    _ , method , file_node = *node
    if method == :require
      file = file_node.children[0]
      @collector.load("#{file}.rb") unless file.include?("parslet")
    end
    if method == :require_relative
      @collector.load File.dirname(@collector.current) + "/" + file_node.children[0] + ".rb"
    end
    if method.to_s.include?("eval")
      @collector.evals << method
    end
    handler_missing(node)
  end

  def on_class node
    @collector.class_defs << node.children[0].children[1]
    handler_missing(node)
  end
  def on_const node
    @collector.const_uses[node.children[1]] += 1
    handler_missing(node)
  end
  def handler_missing node
    type = node.type
    @collector.types[type] += 1
    node.children.each do |kid|
      process(kid) if kid.is_a? AST::Node
    end
  end
end

class Collector

  def initialize
    @parser = Parser::CurrentRuby
    @paths = Bundler.load.specs.collect { |s| s.gem_dir + "/lib/" }
    @class_defs = []
    @const_uses = Hash.new(0)
    @types = Hash.new(0)
    @not_found = []
    @walker = Walker.new(self)
    @files = []
    @evals = []
    @current = nil
  end
  attr_reader :class_defs , :const_uses , :types , :current , :evals

  def file_content file_name
    return nil if @files.include? file_name
    @paths.each do |name|
      next unless File.exist? name + file_name
      @files << file_name
      return File.open(name + file_name).read
    end
    nil
  end

  def run
    load "rubyx.rb"
    load "parser/ruby22.rb"
#    load "../../../.rbenv/versions/2.2.3/lib/ruby/2.2.0/racc/parser.rb"
    print
  end

  def load file
    str = file_content(file)
    return @not_found.push(file) unless str
    ast = @parser.parse str
    was = @current
    @current = file
    @walker.process ast
    @current = was
  end
  def print
    @class_defs.uniq!
    @files.uniq!
    puts "Types #{@types.sort.to_h.to_yaml}"
    puts "Class defs #{@class_defs.length}"
    puts "Class defs #{@class_defs}"
    puts "evals=#{@evals.length} #{@evals.uniq}"
    puts "Not found #{@not_found.length} #{@not_found}"
  end
end

Collector.new.run

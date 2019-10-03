require_relative "normalizer"

module Ruby
  # The if must have condition and a true branch, the false is optional
  #
  # It maps pretty much one to one to a Sol, except for "hoisting"
  #
  # Ruby may have super complex expressions as the condition, whereas
  # Sol may not. Ie of a Statement list all but the last are hoisted to before
  # the sol if. This is equivalent, just easier to compile later
  #
  # The hoisintg code is in Normalizer, as it is also useed in return and while
  class IfStatement < Statement
    include Normalizer

    attr_reader :condition , :if_true , :if_false

    def initialize( cond , if_true , if_false = nil)
      @condition = cond
      @if_true = if_true
      @if_false = if_false
    end

    def to_sol
      cond , hoisted = *normalized_sol(@condition)
      me = Sol::IfStatement.new(cond , @if_true&.to_sol, @if_false&.to_sol)
      return me unless hoisted
      Sol::Statements.new( hoisted ) << me
    end

    def has_false?
      @if_false != nil
    end

    def has_true?
      @if_true != nil
    end

    def to_s(depth = 0)
      parts =  "if(#{@condition})\n"
      parts += "  #{@if_true.to_s(1)}\n" if(@if_true)
      parts += "else\n" if(@if_false)
      parts += "  #{@if_false.to_s(1)}\n" if(@if_false)
      parts += "end\n"
      at_depth(depth , parts )
    end
  end
end

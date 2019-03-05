require_relative "normalizer"

module Ruby
  # The if must have condition and a true branch, the false is optional
  #
  # It maps pretty much one to one to a Vool, except for "hoisting"
  #
  # Ruby may have super complex expressions as the condition, whereas
  # Vool may not. Ie of a Statement list all but the last are hoisted to before
  # the vool if. This is equivalent, just easier to compile later
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

    def to_vool
      cond , rest = *normalize_name(@condition)
      me = Vool::IfStatement.new(cond.to_vool , @if_true&.to_vool, @if_false&.to_vool)
      return me unless rest
      Vool::Statements.new([ rest.to_vool , me])
    end

    def has_false?
      @if_false != nil
    end

    def has_true?
      @if_true != nil
    end

    def to_s(depth = 0)
      parts = ["if(#{@condition})" ]
      parts << @if_true.to_s(depth + 1) if(@if_true)
      parts += ["else" ,  @if_false.to_s(depth + 1)] if(@if_false)
      parts << "end"
      at_depth(depth , *parts )
    end
  end
end

require_relative "normalizer"

module Ruby
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
      me = Vool::IfStatement.new(cond.to_vool , @if_true.to_vool, @if_false&.to_vool)
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
      parts = ["if (#{@condition})" , @body.to_s(depth + 1) ]
      parts += ["else" ,  "@if_false.to_s(depth + 1)"] if(@false)
      parts << "end"
      at_depth(depth , *parts )
    end
  end
end

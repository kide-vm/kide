module Vool
  module Normalizer
    # given a something, determine if it is a Name
    #
    # Return a Name, and a possible rest that has a hoisted part of the statement
    #
    # eg  if( @var % 5) is not normalized
    # but if(tmp_123) is with tmp_123 = @var % 5 hoited above the if
    def normalize_name( condition )
      if( condition.is_a?(ScopeStatement) and condition.single?)
        condition = condition.first
      end
      return [condition] if condition.respond_to?(:slot_definition)
      condition = condition.normalize
      local = "tmp_#{object_id}"
      assign = Statements.new [LocalAssignment.new( local , condition)]
      [LocalVariable.new(local) , assign]
    end
  end
end

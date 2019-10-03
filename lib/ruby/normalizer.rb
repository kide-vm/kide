module Ruby
  module Normalizer
    # Normalize ruby to sol by "flattening" structure
    #
    # This is a common issue for return, if and while , which all need to operate on the
    # last value. In ruby the last value is always implicit, in sol not.
    #
    # A "normalized" structure is first of all not recursive, a list not a tree,
    # The last expression of the list may be one of three things
    # - a constant  (unlikely, unless code is returning /testing a constant)
    # - any variable (same)
    # - a simple call  (most common, but see call "normalisation" in SendStatement)
    #
    # We return the last expression, the one that is returned or tested on, seperately
    #
    def normalized_sol( condition )
      sol_condition = condition.to_sol
      return sol_condition unless( sol_condition.is_a?(Sol::Statements) )
      return sol_condition.first if( sol_condition.single?)
      return [sol_condition.pop , sol_condition ]
    end
  end
end

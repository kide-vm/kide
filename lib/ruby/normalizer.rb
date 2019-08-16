module Ruby
  module Normalizer
    # Normalize ruby to vool by "flattening" structure
    #
    # This is a common issue for return, if and while , which all need to operate on the
    # last value. In ruby the last value is always implicit, in vool not.
    #
    # A "normalized" structure is first of all not recursive, a list not a tree,
    # The last expression of the list may be one of three things
    # - a constant  (unlikely, unless code is returning /testing a constant)
    # - any variable (same)
    # - a simple call  (most common, but see call "normalisation" in SendStatement)
    #
    # We return the last expression, the one that is returned or tested on, seperately
    #
    def normalized_vool( condition )
      vool_condition = condition.to_vool
      return vool_condition unless( vool_condition.is_a?(Vool::Statements) )
      return vool_condition.first if( vool_condition.single?)
      return [vool_condition.pop , vool_condition ]
    end
  end
end

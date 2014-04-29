module Parser
  # Basic types are numbers and strings
  # later maybe arrays and hashes
  # floats ?  
  module BasicTypes
    include Parslet
    rule(:space)  { match('\s').repeat(1) }
    rule(:space?) { space.maybe }
    rule(:eol) { (str("\n") >> space?) | any.absent? }
    
    rule(:double_quote){ str('"') }
    rule(:minus) { str('-') }
    rule(:plus) { str('+') }
    rule(:equal_sign) { str('=') >> space?}
    rule(:sign) { plus | minus }
    rule(:dot) { str('.') }
    rule(:digit) { match('[0-9]') }
    rule(:exponent) { (str('e')| str('E')) }
 
    rule(:true) { str('true').as(:true) >> space?}
    rule(:false) {      str('false').as(:false) >> space?}
    rule(:nil) { str('null').as(:nil) >> space?}
    
    # identifier must start with lower case
    rule(:name)   { (match['a-z'] >> match['a-zA-Z0-9'].repeat).as(:name)  >> space? }
    
    #anything in double quotes
    rule(:string){
      double_quote >> 
      ( double_quote.absent? >> any ).repeat.as(:string) >> 
      double_quote >> space?
    }
    rule(:integer)    { sign.maybe >> digit.repeat(1).as(:integer) >> space? }
    
    rule(:float) { integer >>  dot >> integer >> 
                            (exponent >> sign.maybe >> digit.repeat).maybe >> space?}
  end
end
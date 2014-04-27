module Parser
  # Basic types are numbers and strings
  # later maybe arrays and hashes
  # floats ?  
  module BasicTypes
    include Parslet
    rule(:space)  { match('\s').repeat(1) }
    rule(:space?) { space.maybe }
    rule(:name)   { match('[a-z]').repeat(1).as(:name) >> space? }
    rule(:double_quote){ str('"') }
    rule(:minus) { str('-') }
    rule(:plus) { str('+') }
    rule(:sign) { plus | minus }
    rule(:dot) { str('.') }
    rule(:digit) { match('[0-9]') }
    rule(:exponent) { (str('e')| str('E')) }
    rule(:escaped_character)  { str('\\') >> (match('["\\\\/bfnrt]') | (str('u') >> hexdigit.repeat(4,4))) }
 
    rule(:true) { str('true').as(:true) }
    rule(:false) {      str('false').as(:false) }
    rule(:nil) { str('null').as(:nil) }
    
    #anything in double quotes
    rule(:string){
      double_quote >> (escaped_character | double_quote.absent? >> any ).repeat.as(:string) >> double_quote
    }
    rule(:integer)    { sign.maybe >> digit.repeat(1).as(:integer) >> space? }
    
    rule(:float) { integer >>  dot >> integer >> 
                            (exponent >> sign.maybe >> digit.repeat).maybe}
  end
end
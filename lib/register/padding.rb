
module Padding

  # objects only come in lengths of multiple of 8 words
  # but there is a constant overhead of 2 words, one for type, one for layout
  # and as we would have to subtract 1 to make it work without overhead, we now have to add 7
  def padded len
    a = 32 * (1 + (len + 7)/32 )
    #puts "#{a} for #{len}"
    a
  end

  def padded_words words
    padded(words*4) # 4 == word length, a constant waiting for a home
  end

  def padding_for length
    pad = padded(length) - length - 8 # for header, type and layout
    pad
  end
end

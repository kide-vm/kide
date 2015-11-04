
module Padding

  # objects only come in lengths of multiple of 8 words
  def padded len
    a = 32 * (1 + (len - 1)/32 )
    #puts "#{a} for #{len}"
    a
  end

  def padded_words words
    padded(words*4) # 4 == word length, a constant waiting for a home
  end

  def padding_for length
    pad = padded(length) - length  # for header, layout
    pad
  end
end

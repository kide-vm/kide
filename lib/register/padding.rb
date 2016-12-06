# Helper functions to pad memory.
#
# Meory is always in lines, chunks of 8 words / 32 bytes
module Padding

  # objects only come in lengths of multiple of 8 words / 32 bytes
  # and there is a "hidden" 1 word that is used for debug/check memory corruption
  def padded len
    a = 32 * (1 + (len + 3)/32 )
    #puts "#{a} for #{len}"
    a
  end

  def padded_words words
    padded(words*4) # 4 == word length, a constant waiting for a home
  end

  def padding_for length
    pad = padded(length) - length  # for header, type
    pad
  end
end

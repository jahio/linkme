class Link < ApplicationRecord

  VALUES = (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).freeze

  def encode_link(i)
    # Immediately bail out if i is zero
    if i == 0
      return VALUES[0]
    end
    str = ''
    while i > 0
      str << VALUES[i.modulo(VALUES.length)]
      i = i / VALUES.length
    end
    return str.reverse
  end

  def decode_link(s)
    i = 0
    s.each_char { |c| i = i * VALUES.length + VALUES.index(c) }
    return i
  end

end

class Link < ApplicationRecord
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  # TODO: Validations

  # Lifecycle:
  # 1. Validate presence of URL in submission
  # 2. Validate format of URL (must include http:// or https:// prefix)
  # 3. Validate URL not already in database (redirect if so)
  # 4. Set creator IP, linktime, token
  # 5. Generate the short link and save the record
  # 6. Couple it with the token to build the full URL
  # 7. Render the final short URL to the user, let frontend do the redirect

  # Class method: Link.from_int(int): Given int, give me an encoded string
  # Delegates to private method encode_link under the hood. Essentially a proxy
  # to hide the private interface from the rest of the app for pseudo-security
  # purposes and future flexibility.
  def self.from_int(i)
    self.encode_link(i)
  end

  def self.from_string(s)
    self.decode_link(s)
  end

private

  # The map on the integers here is necessary so we get back actual STRINGS when that
  # series of indices in the array winds up getting referenced, otherwise you get some
  # unusual results, including non-printing, non-ASCII characters!
  VALUES = (('a'..'z').to_a + ('A'..'Z').to_a + ((0..9).to_a.map! { |x| x.to_s })).freeze

  def self.encode_link(i)
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

  def self.decode_link(s)
    i = 0
    s.each_char { |c| i = i * VALUES.length + VALUES.index(c) }
    return i
  end

end

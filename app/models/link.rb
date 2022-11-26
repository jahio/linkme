require 'securerandom'

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

  before_create :set_linktime # Sets off a chain of events if needed - see method comments below

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

  #
  # set_linktime
  #
  # Sets the UNIX timestamp, a float, multiplies that times one thousand for precision, then
  # rounds that value to get an int. Then checks to see if there is even one of those already
  # in the database with the same linktime - if even one exists, the bijective encode function
  # will, by definition, create an identical shortcode, so we need to optionally add a token
  # to it, which if that query produces even one result, we'll call that next. If not, it's
  # just skipped.
  #
  def set_linktime
    lt = (Time.now.utc.to_f * 1000).round
    if Link.where(linktime: lt).count > 0
      # Set a unique token as well
      self.token = set_token(lt)
    end
    self.linktime = lt
  end

  #
  # set_token
  #
  # Given the passed in variable "lt" (linktime), look for the unique combination of links
  # that have that exact same linktime AND the token you're about to generate. Keep going until
  # you get a unique combination (shouldn't take long) and return the generated token.
  #
  def set_token(lt)
    x = 1 # set a control
    token = '' # Placeholder token
    while x > 0 do
      # TODO: Loop logic
      # Break out of loop
      x = 2
    end
    return token
  end

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

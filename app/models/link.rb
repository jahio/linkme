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

  #
  # find_via_path_string(path)
  #
  # Given a string like the following examples, decode the short link and find the original URL.
  #
  #      /Eg8v7X8.8ffb    =>    https://news.ycombinator.com
  #      /22fbv8B         =>    https://rubyonrails.org
  #      /asFbK2b.BBf6    =>    https://youtube.com/erb
  #
  # These are just made up examples to give you an overall idea.
  #
  def self.find_via_shortpath(x)
    # By definition, our delineation suffixes are 4 characters, quite shorter than the normal
    # shortened URL "root" portion, so we can bank on the shorter one being always the token.
    # This will force the shortcode to always be the first element regardless; should normally
    # be that way anyway, but why make assumptions when we can be certain?
    path = x.split(".").sort_by { |s| -s.size } # [0] => the encoded linktime (decode this)
                                                # [1] => the token (if there)
    lt = self.decode_link(path[0])
    if path.length > 1
      return Link.where(linktime: lt, token: path[1]).limit(1).first
    else
      return Link.where(linktime: lt).limit(1).first
    end
  end

  #
  # public_facing
  #
  # Returns a hash of attributes for public consumption, consisting of the full shortened
  # URL (short code plus token with delineator, if any), or errors, if any.
  #
  def public_facing
    # Get the full shortened link - that means the encoded shortcode, plus the token if it
    # exists, with a dot in the middle to delineate between the two.
    short = self.class.encode_link(linktime)

    if(token)
      path = "#{short}.#{token}"
    else
      path = short
    end

    # The full, publicly-suitable hash of things for presentation:
    # NOTE: We're relying on the environment variable to end in a slash here,
    # so if it doesn't, we're going to be returning a malformed URL to the
    # user! Double check that if you're having problems!
    return { original_url: url, short_link: "#{ENV['RUNTIME_URI_BASE']}#{path}" }
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
    # Define precision default, override for test environments - in test,
    # we want reduced precision for collision tests, but we want that higher
    # in dev/prod for realistic runtime experience.
    precision = 1000
    if ENV['RAILS_ENV'] == 'test'
      precision = 100
    end

    lt = (Time.now.to_f * precision).round
    if Link.where(linktime: lt).count > 0
      # Set a unique token as well
      self.token = get_token(lt)
    end
    self.linktime = lt
  end

  #
  # get_token
  #
  # Given the passed in variable "lt" (linktime), look for the unique combination of links
  # that have that exact same linktime AND the token you're about to generate. Keep going until
  # you get a unique combination (shouldn't take long) and return the generated token.
  #
  def get_token(lt)
    x = 1 # set a control
    token = '' # Placeholder token
    while x > 0 do
      # Generate a token, check for the combination of it AND the lt in the database, and if
      # NOT found we're good to set that token and break out, otherwise keep going.
      token = SecureRandom.hex(2)
      if Link.where(linktime: lt, token: token).count == 0
        # Break out of loop
        x = 0
      end
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

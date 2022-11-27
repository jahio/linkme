require 'rails_helper'

RSpec.describe Link, type: :model do
  context 'a working Link object' do
    context 'has a URL that' do
      it 'is not blank' do
      end
      it 'starts with http:// or https://' do
      end
    end
    context 'has a linktime creation int that' do
      it 'corresponds to UNIX time/epoc' do
      end
    end
  end
  context 'when being created' do
    context 'a shortcode is created that' do
      it 'corresponds to UNIX time/linktime property' do
      end
      it 'has a randomized token affixed to compensate for collision probability' do
        # In this case, imagine we've got a lot of traffic and tons of people creating
        # shortened URLs simultaneously. We want to be sure that there isn't a collision,
        # and we don't want URLs getting unnecessarily lengthy if they don't have to,
        # so we only append a token if we absolutely HAVE to do so.
        #
        # To simulate this, we'll just tell Rails to create a ton of basic Link objects
        # all at the same time. In theory, they should all have tokens affixed in spite
        # of the fact that we didn't tell it to do that - it should happen automatically.
        #
        # Start by establishing the number of links in the database with a token attached.
        num_tokens = Link.where("token IS NOT NULL").count

        # Create dummy objects wicked fast - with threads!
        threads = []
        25.times do
          threads << Thread.new { link = create(:link) }
        end
        threads.each { |t| t.join }

        # Now check - is that number unchanged?
        expect(Link.where("token IS NOT NULL").count).to be > num_tokens
      end
    end
  end
  context 'when looking up a shortened url with a token' do
    context 'given both a short code and a token' do
      it 'finds exactly one matching URL in spite of same-second creation' do
      end
    end
  end
end

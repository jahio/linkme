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

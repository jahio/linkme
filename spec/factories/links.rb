require 'securerandom'

FactoryBot.define do
  factory :link do
    url        { Faker::Internet.url }
  end

  factory :link_with_token, class: Link do
    url        { Faker::Internet.url }
    token      { SecureRandom.hex(2) }
  end

  factory :no_proto_link, class: Link do
    url        { (Faker::Internet.url).gsub(/\:\/\//, '') }
  end

  factory :bad_proto_link, class: Link do
    url        { "ftp://" + (Faker::Internet.url).gsub(/\:\/\//, '') }
  end
end

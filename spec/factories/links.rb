FactoryBot.define do
  factory :link do
    url        { Faker::Internet.url }
    creator_ip { Faker::Internet.ip_v6_address }
    linktime   { (Time.now.utc.to_f * 100).round }
  end
end

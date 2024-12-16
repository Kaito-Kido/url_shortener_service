FactoryBot.define do
  factory :url do
    original_url { "http://localhost:3000/#{Faker::Internet.slug}" }
    short_code { SecureRandom.urlsafe_base64(6) }
  end
end

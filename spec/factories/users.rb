FactoryBot.define do
  factory :user do
    email { 'example@mail.com' }
    preferred_price_range { 25_000...45_000 }
  end
end

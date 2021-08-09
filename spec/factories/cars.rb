FactoryBot.define do
  factory :car do
    model { 'Picanto' }
    brand_id { 1 }
    price { 35_000 }
  end
end

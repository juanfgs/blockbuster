FactoryBot.define do
  factory :rental do
    user { nil }
    movie { nil }
    rental_days { 1 }
  end
end

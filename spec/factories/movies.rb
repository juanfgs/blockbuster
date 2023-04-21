FactoryBot.define do
  factory :movie do
    name { Faker::Movie.unique.title }
    description { Faker::Movie.quote }
    genre { Faker::Book.genre }
    release_year { Faker::Number.between(from: 1914, to: 2023) }
    available_copies { Faker::Number.non_zero_digit }
    daily_rental_price { Faker::Number.decimal }
  end
end

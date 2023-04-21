FactoryBot.define do
  factory :user do
    password { Faker::Internet.password }
    email { Faker::Internet.email }
    name { Faker::Internet.name }
  end
end

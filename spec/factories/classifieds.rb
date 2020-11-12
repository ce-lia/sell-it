FactoryBot.define do
  factory :classified do
    user
    title {Faker::Lorem.sentence}
    price {Faker::Number.number(digits: 3)}
    description {Faker::Lorem.paragraph}
  end
end

FactoryBot.define do
  factory :user do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    username { Faker::Internet.user_name }
    password_digest { Faker::Internet.password }
  end
end

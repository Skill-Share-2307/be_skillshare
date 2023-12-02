FactoryBot.define do
  factory :skill do
    name { Faker::Lorem.word }
    proficiency { Faker::Number.between(from: 1, to: 5) }
    user
  end
end

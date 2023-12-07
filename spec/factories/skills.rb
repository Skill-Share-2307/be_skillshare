FactoryBot.define do
  factory :skill do
    name { ['knitting', 'piano', 'juggling'].sample  }
    proficiency { Faker::Number.between(from: 1, to: 5) }
    user
  end
end

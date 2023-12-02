FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    address { Faker::Address.full_address }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
    is_remote { Faker::Boolean.boolean }
    about { Faker::Lorem.sentence }

    transient do
      skills_count { 3 }
    end

    after(:build) do |user, evaluator|
      user.skills = build_list(:skill, evaluator.skills_count, user: user)
    end
  end
end

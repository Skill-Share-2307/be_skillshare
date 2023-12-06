FactoryBot.define do
  factory :meeting do
    date { Faker::Date.forward(days: 10) }
    start_time { Faker::Time.forward(days: 10, period: :morning) }
    end_time { Faker::Time.forward(days: 10, period: :afternoon) }
    is_accepted { false }
    purpose { Faker::Lorem.sentence }
  end
end

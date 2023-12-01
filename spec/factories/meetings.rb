FactoryBot.define do
  factory :meeting do
    date { Faker::Date.forward(days: 10) }
    start_time { Faker::Time.forward(days: 10, period: :morning) }
    end_time { Faker::Time.forward(days: 10, period: :afternoon) }
    is_accepted { Faker::Boolean.boolean }
    purpose { Meeting.purposes.keys.sample }
  end
end

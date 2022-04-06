FactoryBot.define do
  factory :game do
    gid { Faker::Number.unique.number(digits: 8) }
    genres { Faker::Game.genre }
    name { Faker::Game.title }
    platforms { Faker::Game.platform }
    release_dates { Faker::Date.between(from: 20.years.ago, to: 2.years.after).to_s }
    summary { Faker::Lorem.paragraph }
    cover_url { Faker::Internet.url }
  end
end

FactoryBot.define do
  factory :vote do
    status { false }
    user { nil }
    votable { nil }
  end
end

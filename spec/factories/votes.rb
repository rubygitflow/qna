FactoryBot.define do
  factory :vote do
    status { false }
    user
    votable
  end
end

FactoryBot.define do
  factory :answer do
    body { 'MyText' }
    user
    question

    trait :invalid do
      body { nil }
    end
  end
end

FactoryBot.define do
  factory :comment do
    body { "MyComment" }
    user 
    commentable
    
    trait :invalid do
      body { nil }
    end
  end
end

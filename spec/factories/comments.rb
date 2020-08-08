FactoryBot.define do
  factory :comment do
    body { "MyComment" }
    user 
    commentable { nil }
    
    trait :invalid do
      body { nil }
    end

    trait :question do
      commentable { create(:question) }
    end

    trait :answer do
      commentable { create(:answer) }
    end
  end
end

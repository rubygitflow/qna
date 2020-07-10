FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
  end

  # Fix KeyError: Trait not registered: "invalid"
  # https://stackoverflow.com/questions/61124466/rspec-trait-not-registered-error-when-using-faker
  trait :invalid do
    title { nil }
  end  
end

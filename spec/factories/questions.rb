FactoryBot.define do
  sequence :title do |n|
    "Title #{n}"
  end

  factory :question do
    title
    user
    body { 'MyText' }
  end

  # Fix KeyError: Trait not registered: "invalid"
  # https://stackoverflow.com/questions/61124466/rspec-trait-not-registered-error-when-using-faker
  trait :invalid do
    title { nil }
  end  
end

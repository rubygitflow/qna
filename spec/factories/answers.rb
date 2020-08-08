FactoryBot.define do
  factory :answer do
    body { 'MyText' }
    user
    question

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      after :create do |answer|
        file_path1 = Rails.root.join('app', 'assets', 'images', 'qna1.jpg')
        file_path2 = Rails.root.join('app', 'assets', 'images', 'qna2.jpg')
        file1 = fixture_file_upload(file_path1, 'image/jpeg')
        file2 = fixture_file_upload(file_path2, 'image/jpeg')
        answer.files.attach(file1, file2)
      end
    end
  end
end

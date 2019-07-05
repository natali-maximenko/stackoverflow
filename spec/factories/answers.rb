FactoryBot.define do
  sequence :body do |n|
    "Anwer body #{n}"
  end

  factory :answer do
    body
    question
    user

    trait :invalid do
      body { nil }
    end

    factory :answer_with_file do
      user
      question

      after(:create) do |answer|
        file_path = Rails.root.join('spec', 'fixtures', 'image.gif')
        file = fixture_file_upload(file_path, 'image/gif')
        answer.files.attach(file)
      end
    end
  end
end

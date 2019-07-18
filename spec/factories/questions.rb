FactoryBot.define do
  sequence :title do |n|
    "Question ##{n}"
  end

  factory :question do
    title
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_reward do
      reward { create(:reward, question: question) }
    end

    factory :question_with_reward do
      user 
      
      after(:create) do |question|
        create(:reward, question: question)
      end
    end

    factory :question_with_file do
      user

      after(:create) do |question|
        file_path = Rails.root.join('spec', 'fixtures', 'image.gif')
        file = fixture_file_upload(file_path, 'image/gif')
        question.files.attach(file)
      end
    end

    factory :question_with_answers do
      user
      transient do
        answers_count { 5 }
      end
  
      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end
end

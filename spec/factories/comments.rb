FactoryBot.define do
  factory :comment do
    user
    sequence(:body) { |n| "CommentBody#{n}" }

    trait :invalid do
      body { nil }
    end
  end
end 

FactoryBot.define do
  factory :reward do
    name { 'Reward' }
    question
    user

    after(:create) do |reward|
      file_path = Rails.root.join('spec', 'fixtures', 'image.gif')
      file = fixture_file_upload(file_path, 'image/gif')
      reward.file.attach(file)
    end
  end
end

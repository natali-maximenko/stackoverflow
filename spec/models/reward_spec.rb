RSpec.describe Reward, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it 'have attached file' do
    expect(Reward.new.file).to be_an_instance_of(ActiveStorage::Attached::One)  
  end
end

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:girl) { create(:user) }
    let(:question) { create(:question, user: girl) }
    let(:answer) { create(:answer, user: girl) }
    let(:user) { create(:user) }

    it 'when user is not owner it falsey' do
      expect(user.author_of?(answer)).to be_falsey
    end

    it 'when user is owner it truthy' do
      expect(girl.author_of?(answer)).to be_truthy
    end
  end
end

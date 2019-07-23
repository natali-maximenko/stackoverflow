RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }
  it { should validate_presence_of :value }

  describe '#like' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    before { question.like }

    context 'question' do
      it 'create like vote' do
        expect(question.votes.count).to eq(1)
      end

      it 'vote belong to user and is positive' do
        expect(question.votes.first).to have_attributes(user: user, votable: question, value: 1)  
      end
    end

    context 'question change vote' do
      it 'from positive to negative' do
        expect(question.votes.count).to eq(1)
        question.dislike
        expect(question.votes.count).to eq(1)
        expect(question.votes.first).to have_attributes(user: user, votable: question, value: -1)  
      end
    end
  end

  describe '#dislike' do
    let(:user) { create(:user) }
    let(:girl) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    before { answer.dislike }

    context 'answer' do
      it 'create like vote' do
        expect(answer.votes.count).to eq(1)
      end

      it 'vote belong to user and is positive' do
        expect(answer.votes.first).to have_attributes(user: user, votable: answer, value: -1)  
      end
    end

    context 'change vote by answer' do
      it 'from positive to negative' do
        expect(answer.votes.count).to eq(1)
        answer.like
        expect(answer.votes.count).to eq(1)
        expect(answer.votes.first).to have_attributes(user: user, votable: answer, value: 1)  
      end
    end
  end
end

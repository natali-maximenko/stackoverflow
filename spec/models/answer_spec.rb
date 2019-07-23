RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have ne attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)  
  end

  describe '#make_best' do
    let!(:user) { create(:user) }
    let!(:girl) { create(:user) }
    let!(:question) { create(:question_with_reward, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:girl_answer) { create(:answer, question: question, user: girl) }

    context 'when no best answer' do
      before { girl_answer.make_best }
      
      it 'change best to true' do
        girl_answer.reload 
        expect(girl_answer).to be_best
      end

      it 'question has one best answer' do
        best_answers = question.answers.where(best: true)
        expect(best_answers.count).to eq(1)
      end

      it 'add reward to answer owner' do
        expect(girl.rewards.first).to eq(question.reward)
      end
    end

    context 'when question have best answer' do
      before do
        answer.update(best: true)
        girl_answer.make_best 
      end

      it 'change one best answer to another' do
        expect(girl_answer).to be_best
        answer.reload
        expect(answer).to_not be_best
      end

      it 'question has one best answer' do
        best_answers = question.answers.where(best: true)
        expect(best_answers.count).to eq(1)
      end
    end

    context 'when difference questions' do
      let!(:another_question) { create(:question, user: user) }
      let!(:answers) { create_list(:answer, 2, question: another_question, user: girl) }

      before do
        answers.first.update(best: true)
        girl_answer.make_best 
      end
      
      it 'two best answers' do
        girl_answer.reload
        answers.first.reload
        expect(girl_answer).to be_best
        expect(answers.first).to be_best
      end

      it 'each question has one best answer' do
        best_answers = question.answers.where(best: true)
        another_answers = another_question.answers.where(best: true)
        expect(best_answers.count).to eq(1)
        expect(another_answers.count).to eq(1)
      end
    end
  end
end

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe "GET #create" do
    before { login(user) }
    let(:answers) { question.answers }

    context 'with valid attributes' do
      subject { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'saves the new answer in the database' do
        expect{ subject }.to change(answers, :count).by(1)
      end

      it 'redirects to show view' do
        subject
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:invalid_answer) { question.build(:invalid_answer) }
      subject { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }

      it 'does not save the answer' do
        expect{ subject }.to_not change(answers, :count)
      end

      it 're-renders errors' do
        subject
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe "GET #show" do
    before do
      login(user)
      get :show, params: { question_id: question, id: answer }
    end
    let!(:answer) { create(:answer, user: user) }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user: user) }
    subject { delete :destroy, params: { question_id: question, id: answer } }

    context 'owner' do
      before { login(user) }
      let(:answers) { Answer.where(user: user) }

      it 'deletes answer' do
        expect{ subject }.to change(answers, :count).by(-1)
      end

      it 'redirect to question path' do
        subject
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'not owner' do
      before { login(user2) }
      let(:user_answers) { user.answers }

      it 'not deletes answer' do
        expect{ subject }.to_not change(user_answers, :count)
      end

      it 'redirect to root path' do
        subject
        expect(response).to redirect_to root_path
      end
    end
  end
end

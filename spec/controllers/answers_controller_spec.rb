RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe "GET #create" do
    before { login(user) }
    let(:answers) { question.answers }

    context 'with valid attributes' do
      subject { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }

      it 'saves the new answer in the database' do
        expect{ subject }.to change(answers, :count).by(1)
      end

      it 'saves answer by current user' do
        expect{ subject }.to change(user.answers, :count).by(1)
      end

      it 'renders create template'  do
        subject
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:invalid_answer) { question.build(:invalid_answer) }
      subject { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }

      it 'does not save the answer' do
        expect{ subject }.to_not change(answers, :count)
      end

      it 'renders create template' do
        subject
        expect(response).to render_template :create
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

  describe 'POST #best' do
    let!(:answer) { create(:answer, question: question, user: user) }
    subject { post :best, params: { id: answer }, format: :js }

    context 'not owner' do
      before { login(user2) }

      it 'can not set best answer to question' do
        subject 
        question = answer.question.reload 
        expect(question.best_answer).to_not eq(answer)
      end
    end

    context 'owner' do
      before { login(user) }

      it 'set best answer to question' do
        subject 
        question = answer.question.reload 
        expect(question.best_answer).to eq(answer)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'owner' do
      before { login(user) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'not owner' do
      before { login(user2) }

      it 'does not change answer attributes' do
        body = answer.body
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq body
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user: user, question: question) }
    subject { delete :destroy, params: { question_id: question, id: answer }, format: :js }

    context 'owner' do
      before { login(user) }

      it 'deletes answer' do
        expect{ subject }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        subject
        expect(response).to render_template :destroy
      end
    end

    context 'not owner' do
      before { login(user2) }

      it 'not deletes answer' do
        expect{ subject }.to_not change(Answer, :count)
      end

      it 'redirect to root path' do
        subject
        expect(response).to redirect_to root_path
      end
    end
  end
end
